#!/usr/bin/env bash
# Builds invoice-desk-x86_64.pkg.tar.zst from the release tarball with
# makepkg, as a non-root user, and checks it with namcap.
#   scripts/package_arch.sh <dist-dir>
# Run as root in an archlinux:latest container (CI) with the repo as the
# working directory. Reads <dist>/invoice-desk-linux-x64.tar.gz; writes
#   <dist>/invoice-desk-x86_64.pkg.tar.zst
#   <dist>/aur/PKGBUILD and <dist>/aur/.SRCINFO   (filled, for the AUR)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist="$(readlink -f "$1")"
tarball="${dist}/invoice-desk-linux-x64.tar.gz"
[[ -f "${tarball}" ]] || { echo "missing ${tarball}" >&2; exit 1; }

# The version is the tarball's top folder: invoice-desk-X.Y.Z-linux-x64/.
top="$( (tar tzf "${tarball}" || true) | head -1 | cut -d/ -f1)"
version="${top#invoice-desk-}"; version="${version%-linux-x64}"
[[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "bad tarball folder '${top}'" >&2; exit 1; }
sha="$(sha256sum "${tarball}" | cut -d' ' -f1)"

pacman -Syu --noconfirm --needed base-devel namcap >/dev/null
# namcap resolves libraries against installed packages, so install the
# runtime dependencies the PKGBUILD declares.
# shellcheck disable=SC1090
# shellcheck disable=SC2154
deps="$(source "${root}/packaging/arch/PKGBUILD" && echo "${depends[@]}")"
# shellcheck disable=SC2086
pacman -S --noconfirm --needed ${deps} >/dev/null
id builder >/dev/null 2>&1 || useradd -m builder

work="$(mktemp -d)"
sed -e "s/^pkgver=.*/pkgver=${version}/" -e "s/^sha256sums=.*/sha256sums=('${sha}')/" \
  "${root}/packaging/arch/PKGBUILD" > "${work}/PKGBUILD"
# makepkg uses a local file with the source's name instead of downloading.
cp "${tarball}" "${work}/invoice-desk-${version}-linux-x64.tar.gz"
chown -R builder: "${work}"

su builder -c "cd '${work}' && makepkg --nodeps --noconfirm --cleanbuild && makepkg --printsrcinfo > .SRCINFO"
pkg="$(ls "${work}"/invoice-desk-bin-"${version}"-*-x86_64.pkg.tar.zst)"

echo "==> namcap PKGBUILD"
namcap "${work}/PKGBUILD" | tee "${work}/namcap.txt"
echo "==> namcap package"
namcap "${pkg}" | tee -a "${work}/namcap.txt"
# Accepted (docs/RELEASING.md "Package checks"): the prebuilt Flutter
# bundle lives in /opt, is not stripped or relinked, and its libraries keep
# the DT_NEEDED entries Flutter gives them; libdartjni.so names libjvm.so,
# which only loads when a JVM is present (never on desktop). libglvnd
# (EGL/GLES) is dlopen()ed by the engine, so namcap cannot see it is used.
accepted='(ELF files outside of a valid path|ELF file .* is unstripped|lacks FULL RELRO|lacks PIE|Unused shared library|libjvm\.so. is an uninstalled dependency|may not be needed \(.libglvnd.\))'
bad="$(grep -E ' [EW]: ' "${work}/namcap.txt" | grep -vE "${accepted}" || true)"
if [[ -n "${bad}" ]]; then
  echo "::error::namcap reported:"; echo "${bad}"; exit 1
fi

cp "${pkg}" "${dist}/invoice-desk-x86_64.pkg.tar.zst"
mkdir -p "${dist}/aur"
cp "${work}/PKGBUILD" "${work}/.SRCINFO" "${dist}/aur/"
echo "==> ${dist}/invoice-desk-x86_64.pkg.tar.zst (${version})"
