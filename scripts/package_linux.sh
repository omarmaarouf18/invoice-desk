#!/usr/bin/env bash
# Builds the Linux release once and packages that one bundle into dist/,
# under the stable release names (docs/RELEASING.md §Assets):
#   invoice-desk-linux-x64.tar.gz   bundle + desktop file + icons + install.sh
#   InvoiceDesk-x86_64.AppImage     skipped with a warning if appimagetool fails
#   invoice-desk.x86_64.rpm         needs rpmbuild
#   invoice-desk_amd64.deb          needs dpkg-deb + dpkg-shlibdeps (Debian/Ubuntu)
#   SHA256SUMS.txt                  of the files above
# The Arch package is built from the tarball by scripts/package_arch.sh.
#
# Version comes from pubspec.yaml (x.y.z+N) unless VERSION / BUILD_NUMBER are set.
# MAX_GLIBC=2.35 fails the build if any ELF needs a newer glibc (CI sets it).
# Flags: --skip-build (reuse build/linux/x64/release/bundle), --no-appimage,
#        --no-rpm, --no-deb
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${root}"

skip_build=0 want_appimage=1 want_rpm=1 want_deb=1
for arg in "$@"; do
  case "${arg}" in
    --skip-build) skip_build=1 ;;
    --no-appimage) want_appimage=0 ;;
    --no-rpm) want_rpm=0 ;;
    --no-deb) want_deb=0 ;;
    *) echo "unknown option ${arg}" >&2; exit 2 ;;
  esac
done

pub_version="$(sed -n 's/^version:[[:space:]]*//p' pubspec.yaml | head -1)"
VERSION="${VERSION:-${pub_version%%+*}}"
BUILD_NUMBER="${BUILD_NUMBER:-$([[ "${pub_version}" == *+* ]] && echo "${pub_version##*+}" || echo 1)}"
[[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "bad version '${VERSION}'" >&2; exit 1; }
echo "==> Invoice Desk ${VERSION} (build ${BUILD_NUMBER})"

bundle="build/linux/x64/release/bundle"
if [[ ${skip_build} -eq 0 ]]; then
  flutter build linux --release --build-name="${VERSION}" --build-number="${BUILD_NUMBER}"
fi
[[ -x "${bundle}/invoice_desk" ]] || { echo "no bundle at ${bundle}" >&2; exit 1; }

dist="${root}/dist"
rm -rf "${dist}"
mkdir -p "${dist}"
assets=()

# ── RUNPATHs ───────────────────────────────────────────────────────────
# Flutter's plugin builds leave absolute build-machine paths in RUNPATH.
# Package a patched copy: main binary → $ORIGIN/lib, lib/*.so → $ORIGIN.
command -v patchelf >/dev/null 2>&1 || {
  echo "patchelf is required (Fedora: sudo dnf install patchelf; Debian/Ubuntu: sudo apt install patchelf)" >&2
  exit 1
}
is_elf() { [[ "$(head -c 4 "$1" | od -An -c | tr -d ' \n')" == '177ELF' ]]; }
runpath_of() { readelf -d "$1" 2>/dev/null | sed -n 's/.*(\(RUNPATH\|RPATH\)).*\[\(.*\)\]/\2/p'; }

patched="${dist}/stage/bundle"
mkdir -p "${patched}"
cp -a "${bundle}/." "${patched}/"
while IFS= read -r -d '' f; do
  is_elf "${f}" || continue
  [[ -n "$(runpath_of "${f}")" ]] || continue   # no RUNPATH: leave untouched
  rel="${f#"${patched}/"}"
  case "${rel}" in
    invoice_desk) want='$ORIGIN/lib' ;;
    lib/*)        want='$ORIGIN' ;;
    *) echo "unexpected ELF with RUNPATH: ${rel}" >&2; exit 1 ;;
  esac
  patchelf --set-rpath "${want}" "${f}"
done < <(find "${patched}" -type f -print0)

# Fail if any RUNPATH/RPATH entry is anything other than $ORIGIN-relative.
bad=0
while IFS= read -r -d '' f; do
  is_elf "${f}" || continue
  rp="$(runpath_of "${f}")"
  [[ -z "${rp}" ]] && continue
  IFS=':' read -r -a entries <<< "${rp}"
  for e in "${entries[@]}"; do
    if [[ "${e}" != '$ORIGIN' && "${e}" != '$ORIGIN/'* ]]; then
      echo "RUNPATH not relative in ${f#"${patched}/"}: ${rp}" >&2
      bad=1
    fi
  done
done < <(find "${patched}" -type f -print0)
[[ ${bad} -eq 0 ]] || { echo "absolute RUNPATH remains; refusing to package" >&2; exit 1; }
echo "==> RUNPATHs rewritten to \$ORIGIN"
bundle="${patched}"

# ── glibc ceiling ──────────────────────────────────────────────────────
# The newest GLIBC_x.y symbol version any ELF in the bundle needs. The
# README promises the minimum; CI enforces it with MAX_GLIBC.
need_glibc="$(find "${bundle}" -type f \( -name '*.so*' -o -name invoice_desk \) -exec objdump -T {} + 2>/dev/null \
  | grep -o 'GLIBC_[0-9][0-9.]*' | sed 's/GLIBC_//' | sort -uV | tail -1)"
echo "==> needs glibc ${need_glibc:-?}"
if [[ -n "${MAX_GLIBC:-}" ]]; then
  newest="$(printf '%s\n%s\n' "${need_glibc}" "${MAX_GLIBC}" | sort -V | tail -1)"
  [[ "${newest}" == "${MAX_GLIBC}" ]] || { echo "bundle needs glibc ${need_glibc} > MAX_GLIBC ${MAX_GLIBC}" >&2; exit 1; }
fi

# ── tarball ────────────────────────────────────────────────────────────
# The top folder keeps the version; the file name does not (stable URL).
name="invoice-desk-${VERSION}-linux-x64"
stage="${dist}/stage/${name}"
mkdir -p "${stage}/icons"
cp -a "${bundle}/." "${stage}/"
cp packaging/linux/invoice-desk.desktop packaging/linux/invoice-desk.1 packaging/linux/COPYRIGHT.txt "${stage}/"
cp assets/icon/invoice-desk.png "${stage}/"
cp packaging/linux/icons/*.png "${stage}/icons/"
cp assets/icon/invoice-desk.png "${stage}/icons/invoice-desk-256.png"
echo "${VERSION}" > "${stage}/VERSION"
install -m 755 packaging/linux/install.sh packaging/linux/uninstall.sh "${stage}/"
tarball="invoice-desk-linux-x64.tar.gz"
tar -C "${dist}/stage" --owner=0 --group=0 --sort=name -czf "${dist}/${tarball}" "${name}"
assets+=("${tarball}")
echo "==> ${tarball}"

# ── AppImage ───────────────────────────────────────────────────────────
if [[ ${want_appimage} -eq 1 ]]; then
  tools="${root}/.appimage-tools"
  tool="${tools}/appimagetool-x86_64.AppImage"
  if [[ ! -x "${tool}" ]]; then
    mkdir -p "${tools}"
    curl -fsSL -o "${tool}" \
      https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage \
      && chmod +x "${tool}" || rm -f "${tool}"
  fi
  appdir="${dist}/stage/InvoiceDesk.AppDir"
  mkdir -p "${appdir}/usr/lib/invoice-desk"
  cp -a "${bundle}/." "${appdir}/usr/lib/invoice-desk/"
  cp packaging/linux/invoice-desk.desktop "${appdir}/invoice-desk.desktop"
  cp assets/icon/invoice-desk.png "${appdir}/invoice-desk.png"
  ln -s invoice-desk.png "${appdir}/.DirIcon"
  cat > "${appdir}/AppRun" <<'APPRUN'
#!/bin/sh
here="$(dirname "$(readlink -f "$0")")"
exec "${here}/usr/lib/invoice-desk/invoice_desk" "$@"
APPRUN
  chmod 755 "${appdir}/AppRun"
  image="InvoiceDesk-x86_64.AppImage"
  if [[ -x "${tool}" ]] && APPIMAGE_EXTRACT_AND_RUN=1 ARCH=x86_64 VERSION="${VERSION}" \
      "${tool}" --no-appstream "${appdir}" "${dist}/${image}" >"${dist}/stage/appimagetool.log" 2>&1; then
    assets+=("${image}")
    echo "==> ${image}"
  else
    echo "WARNING: AppImage not built (see dist/stage/appimagetool.log); shipping the rest" >&2
  fi
fi

# ── RPM ────────────────────────────────────────────────────────────────
if [[ ${want_rpm} -eq 1 ]]; then
  if command -v rpmbuild >/dev/null 2>&1; then
    rpm_name="invoice-desk.x86_64.rpm"
    rpmbuild -bb packaging/rpm/invoice-desk.spec \
      --define "_topdir ${dist}/stage/rpmbuild" \
      --define "_sourcedir ${dist}" \
      --define "_rpmdir ${dist}" \
      --define "_build_name_fmt ${rpm_name}" \
      --define "pkgversion ${VERSION}" \
      >"${dist}/stage/rpmbuild.log" 2>&1 \
      || { echo "rpmbuild failed, see dist/stage/rpmbuild.log" >&2; exit 1; }
    assets+=("${rpm_name}")
    echo "==> ${rpm_name}"
  else
    echo "WARNING: rpmbuild not found; RPM skipped" >&2
  fi
fi

# ── deb ────────────────────────────────────────────────────────────────
if [[ ${want_deb} -eq 1 ]]; then
  if command -v dpkg-deb >/dev/null 2>&1 && command -v dpkg-shlibdeps >/dev/null 2>&1; then
    deb_name="invoice-desk_amd64.deb"
    packaging/deb/build_deb.sh "${stage}" "${VERSION}" "${dist}/${deb_name}" >"${dist}/stage/deb.log" 2>&1 \
      || { cat "${dist}/stage/deb.log" >&2; echo "deb build failed" >&2; exit 1; }
    assets+=("${deb_name}")
    echo "==> ${deb_name}"
  else
    echo "WARNING: dpkg-deb/dpkg-shlibdeps not found; .deb skipped" >&2
  fi
fi

# ── checksums ──────────────────────────────────────────────────────────
(cd "${dist}" && sha256sum "${assets[@]}" > SHA256SUMS.txt)
rm -rf "${dist}/stage/${name}" "${dist}/stage/InvoiceDesk.AppDir" "${dist}/stage/rpmbuild" "${dist}/stage/bundle"
echo "==> dist/SHA256SUMS.txt"
(cd "${dist}" && ls -lh "${assets[@]}" SHA256SUMS.txt)
