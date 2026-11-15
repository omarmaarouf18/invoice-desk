#!/usr/bin/env bash
# Removes the files install.sh created. Never touches your data folder,
# settings, invoices or backups.
set -euo pipefail

prefix="${HOME}/.local"
share="${XDG_DATA_HOME:-${prefix}/share}"
removed=0
for path in \
  "${prefix}/opt/invoice-desk" \
  "${prefix}/bin/invoice-desk" \
  "${share}/applications/invoice-desk.desktop" \
  "${share}/icons/hicolor/256x256/apps/invoice-desk.png"; do
  if [[ -e "${path}" || -L "${path}" ]]; then
    rm -rf "${path}"
    echo "removed ${path}"
    removed=1
  fi
done

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q "${share}/applications" || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t "${share}/icons/hicolor" 2>/dev/null || true
fi

[[ ${removed} -eq 1 ]] || echo "Invoice Desk was not installed for this user."
echo "Your data and backups were left in place."
