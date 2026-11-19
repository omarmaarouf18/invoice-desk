#!/usr/bin/env bash
# Mounts InvoiceDesk-macOS.dmg, launches the app on a throwaway
# INVOICE_DESK_DATA_DIR, checks it is alive after SMOKE_SECONDS (default 15)
# with its database created and no Dart exception, quits it and detaches.
# On CI only, it launches once more without INVOICE_DESK_DATA_DIR, so the
# default data-dir lookup (path_provider, ~/Library/Application Support) is
# proven. macOS resolves that folder from the account, not $HOME, so off CI the
# launch is skipped and never opens a developer's real data.
#   scripts/smoke_macos.sh dist/InvoiceDesk-macOS.dmg
set -euo pipefail

dmg="$1"; secs="${SMOKE_SECONDS:-15}"
mnt="$(mktemp -d)"; data="$(mktemp -d)"
hdiutil attach -nobrowse -readonly -mountpoint "${mnt}" "${dmg}" >/dev/null
trap 'hdiutil detach "${mnt}" -force >/dev/null 2>&1 || true' EXIT

app="${mnt}/Invoice Desk.app"
[[ -L "${mnt}/Applications" ]] || { echo "::error::no Applications link in the dmg"; exit 1; }
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' -c 'Print :CFBundleShortVersionString' "${app}/Contents/Info.plist"
codesign --verify --deep --strict "${app}" || { echo "::error::signature does not verify"; exit 1; }

support="${HOME}/Library/Application Support"
find_default_db() { find "${support}" -maxdepth 2 -name invoice_desk.sqlite -print -quit 2>/dev/null; }

# launch <directory to expect the database in> [env assignments…]
launch() {
  local expect="$1"; shift
  local log; log="$(mktemp)"
  env "$@" "${app}/Contents/MacOS/Invoice Desk" >"${log}" 2>&1 &
  local pid=$!
  sleep "${secs}"
  if ! kill -0 "${pid}" 2>/dev/null; then
    cat "${log}"; wait "${pid}" || true; echo "::error::app exited early"; exit 1
  fi
  kill -TERM "${pid}"
  for _ in $(seq 1 10); do kill -0 "${pid}" 2>/dev/null || break; sleep 1; done
  if kill -0 "${pid}" 2>/dev/null; then kill -KILL "${pid}"; echo "::error::app ignored SIGTERM"; exit 1; fi
  cat "${log}"
  find "${expect}" -maxdepth 2 -name invoice_desk.sqlite -print -quit | grep -q . \
    || { echo "::error::database was not created under ${expect}"; exit 1; }
  if grep -E "Unhandled Exception|\[ERROR:flutter|Exception caught by" "${log}"; then
    echo "::error::Dart exception during smoke run"; exit 1
  fi
}

launch "${data}" INVOICE_DESK_DATA_DIR="${data}"
mode="temp data dir"
if [[ "${CI:-}" == "true" ]]; then
  [[ -z "$(find_default_db)" ]] || { echo "::error::a database already exists under ${support}; refusing to launch on it"; exit 1; }
  launch "${support}" -u INVOICE_DESK_DATA_DIR
  db="$(find_default_db)"
  echo "default data dir: $(dirname "${db}")"
  rm -rf "$(dirname "${db}")"
  mode="temp data dir, default data dir"
else
  mode="temp data dir; default data dir skipped off CI"
fi
echo "smoke OK: $(basename "${dmg}") (${secs} s each: ${mode})"
