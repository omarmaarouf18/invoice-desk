#!/usr/bin/env bash
# Installs one Linux package, launches it headless and removes it again.
#   scripts/smoke_linux.sh <invoice-desk_amd64.deb | invoice-desk.x86_64.rpm |
#                           invoice-desk-x86_64.pkg.tar.zst | InvoiceDesk-x86_64.AppImage |
#                           invoice-desk-linux-x64.tar.gz>
# Run as root inside a clean distro container (CI: ubuntu:22.04, debian:12,
# fedora:latest, archlinux:latest) or, for the AppImage/tarball, as a normal
# user on the runner. Passes when the app:
#   - is still running after SMOKE_SECONDS (default 15) under xvfb-run,
#   - created its database in a throwaway INVOICE_DESK_DATA_DIR,
#   - logged no Dart/Flutter exception,
#   - stops on SIGTERM;
# and the package removal leaves that data folder alone.
set -euo pipefail

pkg="$(readlink -f "$1")"
secs="${SMOKE_SECONDS:-15}"
[[ -f "${pkg}" ]] || { echo "no such package: $1" >&2; exit 2; }
sudo=(); [[ "$(id -u)" -eq 0 ]] || sudo=(sudo)

# ── a virtual display and software GL drivers only: everything else the
#    app needs must come from the package's own dependencies ────────────
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  "${sudo[@]}" apt-get update -qq
  "${sudo[@]}" apt-get install -y -qq xvfb xauth libgl1-mesa-dri procps >/dev/null
elif command -v dnf >/dev/null 2>&1; then
  "${sudo[@]}" dnf install -y -q xorg-x11-server-Xvfb xorg-x11-xauth mesa-dri-drivers procps-ng >/dev/null
elif command -v pacman >/dev/null 2>&1; then
  "${sudo[@]}" pacman -Sy --noconfirm --needed xorg-server-xvfb xorg-xauth mesa procps-ng >/dev/null
fi

# ── install ────────────────────────────────────────────────────────────
remove=()
case "${pkg}" in
  *.deb)
    "${sudo[@]}" apt-get install -y -qq "${pkg}" >/dev/null
    dpkg -s invoice-desk | grep -E '^(Status|Version):'
    exe=/usr/bin/invoice-desk; remove=("${sudo[@]}" apt-get remove -y -qq invoice-desk) ;;
  *.rpm)
    "${sudo[@]}" dnf install -y -q "${pkg}" >/dev/null
    rpm -q invoice-desk && rpm -V invoice-desk
    exe=/usr/bin/invoice-desk; remove=("${sudo[@]}" dnf remove -y -q invoice-desk) ;;
  *.pkg.tar.zst)
    "${sudo[@]}" pacman -U --noconfirm "${pkg}" >/dev/null
    pacman -Qi invoice-desk-bin | grep -E '^(Name|Version)'
    exe=/usr/bin/invoice-desk; remove=("${sudo[@]}" pacman -R --noconfirm invoice-desk-bin) ;;
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
data="$(mktemp -d)"; log="$(mktemp)"
set +e
INVOICE_DESK_DATA_DIR="${data}" xvfb-run -a timeout -s TERM -k 5 "${secs}" "${exe}" >"${log}" 2>&1
rc=$?
set -e
cat "${log}"
# 124 = still running when the timeout sent SIGTERM, and it then stopped.
[[ ${rc} -eq 124 ]] || { echo "::error::app exited early or ignored SIGTERM (exit ${rc})"; exit 1; }
[[ -f "${data}/invoice_desk.sqlite" ]] || { echo "::error::database was not created"; exit 1; }
if grep -E "Unhandled Exception|\[ERROR:flutter|Exception caught by" "${log}"; then
  echo "::error::Dart exception during smoke run"; exit 1
fi
if pgrep -f "${exe}" >/dev/null 2>&1; then echo "::error::app still running after SIGTERM"; exit 1; fi

# ── remove ─────────────────────────────────────────────────────────────
if [[ ${#remove[@]} -gt 0 ]]; then
  "${remove[@]}" >/dev/null
  [[ ! -e /opt/invoice-desk/invoice_desk && ! -e /usr/bin/invoice-desk ]] || { echo "::error::files left after removal"; exit 1; }
fi
[[ -f "${data}/invoice_desk.sqlite" ]] || { echo "::error::removal touched the data folder"; exit 1; }
echo "smoke OK: $(basename "${pkg}") (${secs} s, temp data dir)"
