#!/usr/bin/env bash
# Installs Invoice Desk for the current user (no root needed).
# Your invoices and backups live in your data folder and are never touched.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
prefix="${HOME}/.local"
app_dir="${prefix}/opt/invoice-desk"
bin_link="${prefix}/bin/invoice-desk"
desktop="${XDG_DATA_HOME:-${prefix}/share}/applications/invoice-desk.desktop"
icon="${XDG_DATA_HOME:-${prefix}/share}/icons/hicolor/256x256/apps/invoice-desk.png"

for f in invoice_desk lib data invoice-desk.desktop invoice-desk.png; do
  [[ -e "${here}/${f}" ]] || { echo "missing ${f} next to install.sh" >&2; exit 1; }
done

rm -rf "${app_dir}"
mkdir -p "${app_dir}" "$(dirname "${bin_link}")" "$(dirname "${desktop}")" "$(dirname "${icon}")"
cp -a "${here}/invoice_desk" "${here}/lib" "${here}/data" "${app_dir}/"
ln -sfn "${app_dir}/invoice_desk" "${bin_link}"

# Absolute Exec so the menu entry works even if ~/.local/bin is not on PATH.
sed "s|^Exec=.*|Exec=${bin_link}|" "${here}/invoice-desk.desktop" > "${desktop}"
install -m 644 "${here}/invoice-desk.png" "${icon}"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q "$(dirname "${desktop}")" || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t "${XDG_DATA_HOME:-${prefix}/share}/icons/hicolor" 2>/dev/null || true
fi

echo "Installed Invoice Desk to ${app_dir}"
echo "Run it from the app menu or with: ${bin_link}"
