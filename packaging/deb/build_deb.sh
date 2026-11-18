#!/usr/bin/env bash
# Builds invoice-desk_amd64.deb from an unpacked release tarball folder.
#   packaging/deb/build_deb.sh <tarball-folder> <version> <out.deb>
# Layout: /opt/invoice-desk (the bundle), /usr/bin/invoice-desk symlink,
# the .desktop file, hicolor icons, a man page and the copyright file.
# Depends are computed by dpkg-shlibdeps from the ELF files, so they match
# what the bundle really links against on the build distro (ubuntu-22.04).
set -euo pipefail

src="$(cd "$1" && pwd)"; version="$2"; out="$3"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
work="$(mktemp -d)"; trap 'rm -rf "${work}"' EXIT
pkg="${work}/pkg"

install -d "${pkg}/opt/invoice-desk" "${pkg}/usr/bin" "${pkg}/DEBIAN"
cp -a "${src}/invoice_desk" "${src}/lib" "${src}/data" "${pkg}/opt/invoice-desk/"
ln -s /opt/invoice-desk/invoice_desk "${pkg}/usr/bin/invoice-desk"
install -Dm644 "${src}/invoice-desk.desktop" "${pkg}/usr/share/applications/invoice-desk.desktop"
for size in 48 64 128 256; do
  install -Dm644 "${src}/icons/invoice-desk-${size}.png" \
    "${pkg}/usr/share/icons/hicolor/${size}x${size}/apps/invoice-desk.png"
done
install -d "${pkg}/usr/share/man/man1"
gzip -9n -c "${src}/invoice-desk.1" > "${pkg}/usr/share/man/man1/invoice-desk.1.gz"
install -Dm644 "${here}/copyright" "${pkg}/usr/share/doc/invoice-desk/copyright"
printf 'invoice-desk (%s) stable; urgency=medium\n\n  * Release %s. See CHANGELOG.md in the source repository.\n\n -- Omar Maarouf <omarmaarouf18@users.noreply.github.com>  %s\n' \
  "${version}" "${version}" "$(date -u -R)" | gzip -9n > "${pkg}/usr/share/doc/invoice-desk/changelog.gz"
install -Dm644 "${here}/lintian-overrides" "${pkg}/usr/share/lintian/overrides/invoice-desk"
find "${pkg}" -type d -exec chmod 755 {} +

# Shared-library dependencies. The bundle's own lib/ is a private search
# path (-l); libraries found there are not package dependencies.
mkdir -p "${work}/debian"
printf 'Source: invoice-desk\n\nPackage: invoice-desk\nArchitecture: amd64\n' > "${work}/debian/control"
mapfile -t elves < <(find "${pkg}/opt/invoice-desk" -type f \( -name '*.so' -o -name invoice_desk \))
depends="$(cd "${work}" && dpkg-shlibdeps -O -l"${pkg}/opt/invoice-desk/lib" --ignore-missing-info "${elves[@]}" \
  | sed -n 's/^shlibs:Depends=//p')"
[[ "${depends}" == *libgtk-3-0* ]] || { echo "dpkg-shlibdeps did not find GTK: '${depends}'" >&2; exit 1; }
# The Flutter engine dlopen()s EGL and GLES at start-up, which
# dpkg-shlibdeps cannot see; without them the app aborts on launch.
depends="${depends}, libegl1, libgles2"
echo "Depends: ${depends}"

size="$(du -sk --exclude=DEBIAN "${pkg}" | cut -f1)"
sed -e "s|@VERSION@|${version}|" -e "s|@SIZE@|${size}|" -e "s|@DEPENDS@|${depends}|" \
  "${here}/control.in" > "${pkg}/DEBIAN/control"
cat > "${pkg}/DEBIAN/postinst" <<'POST'
#!/bin/sh
set -e
if [ "$1" = "configure" ]; then
  command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database -q /usr/share/applications || true
  command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -q -t /usr/share/icons/hicolor || true
fi
POST
cp "${pkg}/DEBIAN/postinst" "${pkg}/DEBIAN/postrm"
sed -i 's/= "configure"/= "remove"/' "${pkg}/DEBIAN/postrm"
chmod 755 "${pkg}/DEBIAN/postinst" "${pkg}/DEBIAN/postrm"

dpkg-deb --root-owner-group -Zxz --build "${pkg}" "${out}"
dpkg-deb --info "${out}"
