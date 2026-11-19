#!/usr/bin/env bash
# Installs one Linux package, launches it headless and removes it again.
#   scripts/smoke_linux.sh <invoice-desk_amd64.deb | invoice-desk.x86_64.rpm |
#                           invoice-desk-x86_64.pkg.tar.zst | InvoiceDesk-x86_64.AppImage |
#                           invoice-desk-linux-x64.tar.gz>
# Run as root inside a clean distro container (CI: ubuntu:22.04, debian:12,
# fedora:latest, archlinux:latest) or, for the AppImage/tarball, as a normal
# user on the runner. Passes when the app:
#   - is still running after SMOKE_SECONDS (default 15) under xvfb-run,
#   - created its database in a throwaway INVOICE_DESK_DATA_DIR, and, in a
#     second launch without it, in the default data dir of a throwaway HOME,
#   - logged no Dart/Flutter exception,
#   - stops on SIGTERM;
# and the package removal leaves that data folder alone.
set -euo pipefail

pkg="$(readlink -f "$1")"
secs="${SMOKE_SECONDS:-15}"
[[ -f "${pkg}" ]] || { echo "no such package: $1" >&2; exit 2; }
sudo=(); [[ "$(id -u)" -eq 0 ]] || sudo=(sudo)

# ── package-manager calls: time-boxed and logged ───────────────────────
# pm <seconds> <command…> runs one apt/dnf/pacman call with no stdin, its
# output appended to a log. On failure or timeout the log is printed, so a
# stalled mirror or a prompt shows up in the job log instead of a silent
# hang. Worst case (apt: 60 + 120 + 120 + 60 s, plus 10 s kill grace each)
# stays well under the install job's timeout-minutes: 10.
pm_log="$(mktemp)"
pm() {
  local limit="$1"; shift
  echo "==> $* (limit ${limit} s)"
  echo "+ $(date -u +%H:%M:%S) $*" >>"${pm_log}"
  local rc=0
  timeout -k 10 "${limit}" "${sudo[@]}" "$@" </dev/null >>"${pm_log}" 2>&1 || rc=$?
  if [[ ${rc} -ne 0 ]]; then
    echo "::group::package manager log (${pm_log})"; cat "${pm_log}"; echo "::endgroup::"
    if [[ ${rc} -eq 124 || ${rc} -eq 137 ]]; then
      echo "::error::timed out after ${limit} s: $*"
    else
      echo "::error::failed (exit ${rc}): $*"
    fi
    exit 1
  fi
}
apt_opts=(-o Acquire::Retries=3 -o Acquire::http::Timeout=30 -o Dpkg::Use-Pty=0)

# ── a virtual display and software GL drivers only: everything else the
#    app needs must come from the package's own dependencies ────────────
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  pm 60 env DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" update
  pm 120 env DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install -y xvfb xauth libgl1-mesa-dri procps
elif command -v dnf >/dev/null 2>&1; then
  pm 180 dnf install -y xorg-x11-server-Xvfb xorg-x11-xauth mesa-dri-drivers procps-ng
elif command -v pacman >/dev/null 2>&1; then
  pm 180 pacman -Sy --noconfirm --needed xorg-server-xvfb xorg-xauth mesa procps-ng
fi

# ── install ────────────────────────────────────────────────────────────
remove=()
case "${pkg}" in
  *.deb)
    pm 120 env DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install -y "${pkg}"
    dpkg -s invoice-desk | grep -E '^(Status|Version):'
    exe=/usr/bin/invoice-desk; remove=(env DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" remove -y invoice-desk) ;;
  *.rpm)
    pm 120 dnf install -y "${pkg}"
    rpm -q invoice-desk && rpm -V invoice-desk
    exe=/usr/bin/invoice-desk; remove=(dnf remove -y invoice-desk) ;;
  *.pkg.tar.zst)
    pm 120 pacman -U --noconfirm "${pkg}"
    pacman -Qi invoice-desk-bin | grep -E '^(Name|Version)'
    exe=/usr/bin/invoice-desk; remove=(pacman -R --noconfirm invoice-desk-bin) ;;
  *.AppImage)
    work="$(mktemp -d)"; cp "${pkg}" "${work}/app.AppImage"; chmod +x "${work}/app.AppImage"
    export APPIMAGE_EXTRACT_AND_RUN=1   # no FUSE in containers/runners
    exe="${work}/app.AppImage" ;;
  *.tar.gz)
    work="$(mktemp -d)"; tar xzf "${pkg}" -C "${work}"
    exe="$(echo "${work}"/invoice-desk-*-linux-x64/invoice_desk)"; cat "$(dirname "${exe}")/VERSION" ;;
  *) echo "unknown package type: ${pkg}" >&2; exit 2 ;;
esac
[[ -x "${exe}" ]] || { echo "not installed: ${exe}" >&2; exit 1; }
[[ "${exe}" != /usr/bin/* ]] || test -f /usr/share/applications/invoice-desk.desktop

# ── launch ─────────────────────────────────────────────────────────────
# launch <data dir to expect the database in> [env assignments…]
launch() {
  local expect="$1"; shift
  local log; log="$(mktemp)"
  set +e
  env "$@" xvfb-run -a timeout -s TERM -k 5 "${secs}" "${exe}" >"${log}" 2>&1
  local rc=$?
  set -e
  cat "${log}"
  # 124 = still running when the timeout sent SIGTERM, and it then stopped.
  [[ ${rc} -eq 124 ]] || { echo "::error::app exited early or ignored SIGTERM (exit ${rc})"; exit 1; }
  find "${expect}" -name invoice_desk.sqlite -print -quit | grep -q . \
    || { echo "::error::database was not created under ${expect}"; exit 1; }
  if grep -E "Unhandled Exception|\[ERROR:flutter|Exception caught by" "${log}"; then
    echo "::error::Dart exception during smoke run"; exit 1
  fi
  if pgrep -f "${exe}" >/dev/null 2>&1; then echo "::error::app still running after SIGTERM"; exit 1; fi
}

# 1. Throwaway INVOICE_DESK_DATA_DIR.
data="$(mktemp -d)"
launch "${data}" INVOICE_DESK_DATA_DIR="${data}"

# 2. No override: the default data-dir lookup (path_provider, no `jni` in the
#    bundle) on a throwaway HOME, so a real user's data is never opened.
home="$(mktemp -d)"
launch "${home}" -u INVOICE_DESK_DATA_DIR HOME="${home}" XDG_DATA_HOME="${home}/.local/share" \
  XDG_CONFIG_HOME="${home}/.config" XDG_CACHE_HOME="${home}/.cache"
echo "default data dir: $(dirname "$(find "${home}" -name invoice_desk.sqlite -print -quit)")"

# ── remove ─────────────────────────────────────────────────────────────
if [[ ${#remove[@]} -gt 0 ]]; then
  pm 60 "${remove[@]}"
  [[ ! -e /opt/invoice-desk/invoice_desk && ! -e /usr/bin/invoice-desk ]] || { echo "::error::files left after removal"; exit 1; }
fi
[[ -f "${data}/invoice_desk.sqlite" ]] || { echo "::error::removal touched the data folder"; exit 1; }
echo "smoke OK: $(basename "${pkg}") (2 × ${secs} s: temp data dir, default data dir on a temp HOME)"
