#!/usr/bin/env bash
# Mounts InvoiceDesk-macOS.dmg, launches the app on a throwaway
# INVOICE_DESK_DATA_DIR, checks it is alive after SMOKE_SECONDS (default 15)
# with its database created and no Dart exception, quits it and detaches.
#   scripts/smoke_macos.sh dist/InvoiceDesk-macOS.dmg
set -euo pipefail

dmg="$1"; secs="${SMOKE_SECONDS:-15}"
mnt="$(mktemp -d)"; data="$(mktemp -d)"; log="$(mktemp)"
hdiutil attach -nobrowse -readonly -mountpoint "${mnt}" "${dmg}" >/dev/null
trap 'hdiutil detach "${mnt}" -force >/dev/null 2>&1 || true' EXIT

app="${mnt}/Invoice Desk.app"
[[ -L "${mnt}/Applications" ]] || { echo "::error::no Applications link in the dmg"; exit 1; }
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' -c 'Print :CFBundleShortVersionString' "${app}/Contents/Info.plist"
codesign --verify --deep --strict "${app}" || { echo "::error::signature does not verify"; exit 1; }

INVOICE_DESK_DATA_DIR="${data}" "${app}/Contents/MacOS/Invoice Desk" >"${log}" 2>&1 &
pid=$!
sleep "${secs}"
if ! kill -0 "${pid}" 2>/dev/null; then
  cat "${log}"; wait "${pid}" || true; echo "::error::app exited early"; exit 1
fi
kill -TERM "${pid}"
for _ in $(seq 1 10); do kill -0 "${pid}" 2>/dev/null || break; sleep 1; done
if kill -0 "${pid}" 2>/dev/null; then kill -KILL "${pid}"; echo "::error::app ignored SIGTERM"; exit 1; fi
cat "${log}"
[[ -f "${data}/invoice_desk.sqlite" ]] || { echo "::error::database was not created"; exit 1; }
if grep -E "Unhandled Exception|\[ERROR:flutter|Exception caught by" "${log}"; then
  echo "::error::Dart exception during smoke run"; exit 1
fi
echo "smoke OK: $(basename "${dmg}") (${secs} s, temp data dir)"
