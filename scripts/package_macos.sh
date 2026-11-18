#!/usr/bin/env bash
# Builds the macOS release and packages it as dist/InvoiceDesk-macOS.dmg
# (macos-15 runner). Flutter release builds are universal (arm64 + x86_64);
# the architectures found are printed and written to dist/macos-archs.txt.
#
# Signing and notarization run only when every Apple secret is set
# (release decision R5); otherwise the app keeps Flutter's ad-hoc signature:
#   MACOS_CERT_P12_BASE64, MACOS_CERT_PASSWORD, MACOS_KEYCHAIN_PASSWORD,
#   APPLE_TEAM_ID, APPLE_API_KEY_ID, APPLE_API_ISSUER_ID, APPLE_API_KEY_P8_BASE64
# Secrets are never echoed: they go to files under a private temp folder and
# a temporary keychain, both removed on exit (CI also runs
# scripts/package_macos.sh --cleanup in an always() step).
#
# Version comes from pubspec.yaml unless VERSION / BUILD_NUMBER are set.
# Flags: --skip-build, --cleanup (only remove the keychain/temp files)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${root}"
keychain="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/invoice-desk-signing.keychain-db"
secrets_dir="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/invoice-desk-signing"

cleanup() {
  if [[ -f "${keychain}" ]]; then security delete-keychain "${keychain}" || true; fi
  rm -rf "${secrets_dir}"
}

skip_build=0
for arg in "$@"; do
  case "${arg}" in
    --skip-build) skip_build=1 ;;
    --cleanup) cleanup; exit 0 ;;
    *) echo "unknown option ${arg}" >&2; exit 2 ;;
  esac
done
trap cleanup EXIT

pub_version="$(sed -n 's/^version:[[:space:]]*//p' pubspec.yaml | head -1)"
VERSION="${VERSION:-${pub_version%%+*}}"
BUILD_NUMBER="${BUILD_NUMBER:-$([[ "${pub_version}" == *+* ]] && echo "${pub_version##*+}" || echo 1)}"
[[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "bad version '${VERSION}'" >&2; exit 1; }
echo "==> Invoice Desk ${VERSION} (build ${BUILD_NUMBER})"

if [[ ${skip_build} -eq 0 ]]; then
  flutter build macos --release --build-name="${VERSION}" --build-number="${BUILD_NUMBER}"
fi
app="build/macos/Build/Products/Release/Invoice Desk.app"
exe="${app}/Contents/MacOS/Invoice Desk"
[[ -x "${exe}" ]] || { echo "no app at ${app}" >&2; exit 1; }

dist="${root}/dist"
rm -rf "${dist}"; mkdir -p "${dist}"

archs="$(lipo -archs "${exe}")"
echo "==> architectures: ${archs}"
echo "${archs}" > "${dist}/macos-archs.txt"
[[ " ${archs} " == *" arm64 "* ]] || { echo "the app has no arm64 slice" >&2; exit 1; }
[[ " ${archs} " == *" x86_64 "* ]] || echo "::warning::not universal (${archs}): Intel Macs are not supported by this build"
plist_version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "${app}/Contents/Info.plist")"
[[ "${plist_version}" == "${VERSION}" ]] || { echo "Info.plist version ${plist_version} != ${VERSION}" >&2; exit 1; }

# ── signing (only with every secret) ───────────────────────────────────
sign=1
for v in MACOS_CERT_P12_BASE64 MACOS_CERT_PASSWORD MACOS_KEYCHAIN_PASSWORD APPLE_TEAM_ID \
         APPLE_API_KEY_ID APPLE_API_ISSUER_ID APPLE_API_KEY_P8_BASE64; do
  [[ -n "${!v:-}" ]] || sign=0
done

identity=""
if [[ ${sign} -eq 1 ]]; then
  echo "==> signing with the Developer ID certificate"
  mkdir -p "${secrets_dir}"; chmod 700 "${secrets_dir}"
  printf '%s' "${MACOS_CERT_P12_BASE64}" | base64 --decode > "${secrets_dir}/cert.p12"
  printf '%s' "${APPLE_API_KEY_P8_BASE64}" | base64 --decode > "${secrets_dir}/AuthKey.p8"
  security create-keychain -p "${MACOS_KEYCHAIN_PASSWORD}" "${keychain}"
  security set-keychain-settings -lut 21600 "${keychain}"
  security unlock-keychain -p "${MACOS_KEYCHAIN_PASSWORD}" "${keychain}"
  security import "${secrets_dir}/cert.p12" -k "${keychain}" -P "${MACOS_CERT_PASSWORD}" \
    -T /usr/bin/codesign -T /usr/bin/security >/dev/null
  security set-key-partition-list -S apple-tool:,apple: -s -k "${MACOS_KEYCHAIN_PASSWORD}" "${keychain}" >/dev/null
  # shellcheck disable=SC2046
  security list-keychains -d user -s "${keychain}" $(security list-keychains -d user | tr -d '"')
  identity="$(security find-identity -v -p codesigning "${keychain}" \
    | sed -n "s/.*\"\(Developer ID Application: .*(${APPLE_TEAM_ID})\)\"/\1/p" | head -1)"
  [[ -n "${identity}" ]] || { echo "no 'Developer ID Application' identity for team ${APPLE_TEAM_ID} in the certificate" >&2; exit 1; }

  cs=(codesign --force --timestamp --options runtime --keychain "${keychain}" --sign "${identity}")
  # Nested code first, innermost first: dylibs, then frameworks, then the app.
  while IFS= read -r -d '' f; do "${cs[@]}" "${f}"; done \
    < <(find "${app}/Contents" -type f \( -name '*.dylib' -o -name '*.so' \) -print0)
  while IFS= read -r -d '' f; do "${cs[@]}" "${f}"; done \
    < <(find "${app}/Contents/Frameworks" -depth -type d -name '*.framework' -print0)
  "${cs[@]}" --entitlements macos/Runner/Release.entitlements "${app}"
  codesign --verify --deep --strict --verbose=2 "${app}"
else
  echo "::warning::Apple signing secrets not set; the app ships unsigned (ad-hoc)"
fi

# ── dmg ────────────────────────────────────────────────────────────────
dmg="${dist}/InvoiceDesk-macOS.dmg"
stage="$(mktemp -d)"
cp -R "${app}" "${stage}/"
ln -s /Applications "${stage}/Applications"
hdiutil create -volname "Invoice Desk ${VERSION}" -srcfolder "${stage}" -fs HFS+ -format UDZO -ov "${dmg}" >/dev/null
rm -rf "${stage}"

if [[ ${sign} -eq 1 ]]; then
  codesign --force --timestamp --keychain "${keychain}" --sign "${identity}" "${dmg}"
  echo "==> notarizing (waits for Apple)"
  result="$(xcrun notarytool submit "${dmg}" --key "${secrets_dir}/AuthKey.p8" \
    --key-id "${APPLE_API_KEY_ID}" --issuer "${APPLE_API_ISSUER_ID}" --wait --output-format json)"
  status="$(plutil -extract status raw -o - - <<< "${result}")"
  id="$(plutil -extract id raw -o - - <<< "${result}")"
  if [[ "${status}" != "Accepted" ]]; then
    xcrun notarytool log "${id}" --key "${secrets_dir}/AuthKey.p8" \
      --key-id "${APPLE_API_KEY_ID}" --issuer "${APPLE_API_ISSUER_ID}" || true
    echo "notarization ${status}" >&2; exit 1
  fi
  xcrun stapler staple "${dmg}"
  xcrun stapler validate "${dmg}"
  spctl -a -t open --context context:primary-signature -vv "${dmg}"
  spctl -a -t exec -vv "${app}"
fi

(cd "${dist}" && ls -lh InvoiceDesk-macOS.dmg)
