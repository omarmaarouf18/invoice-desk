#!/usr/bin/env bash
# Runs the CI gates locally, in the same order as .github/workflows/ci.yml,
# so nothing depends on GitHub Actions to be verified.
#
#   ./scripts/ci_local.sh               # everything
#   ./scripts/ci_local.sh --no-package  # skip the slow build/package step
#
# Gates whose tool is missing are reported as SKIPPED, not passed. Windows
# and macOS builds only run on those platforms.
set -uo pipefail
cd "$(dirname "$0")/.."

PACKAGE=1
[[ "${1:-}" == "--no-package" ]] && PACKAGE=0

results=()
failed=0
LOG=$(mktemp -d)

step() { # name, command...
  local name=$1; shift
  printf '\n\033[1m▶ %s\033[0m\n' "$name"
  local t0=$SECONDS
  if "$@" >"$LOG/step.log" 2>&1; then
    tail -n 25 "$LOG/step.log"
    results+=("PASS  $name ($((SECONDS - t0))s)")
  else
    tail -n 60 "$LOG/step.log"
    results+=("FAIL  $name ($((SECONDS - t0))s)")
    failed=1
  fi
}

skip() { results+=("SKIP  $1 — $2"); printf '\n\033[1m▶ %s\033[0m\nSKIPPED: %s\n' "$1" "$2"; }

clean_tree() {
  local paths=("$@")
  local dirty
  dirty=$(git status --porcelain -- "${paths[@]}")
  if [[ -n "$dirty" ]]; then echo "$dirty"; return 1; fi
  echo "clean"
}

# 1. quality
step "pub get" flutter pub get
step "format" dart format --set-exit-if-changed --output=none lib test tool
step "analyze --fatal-infos" flutter analyze --fatal-infos
step "layering test" flutter test test/architecture
step "size check" dart run tool/check_sizes.dart

# 2. codegen freshness (compares against the working tree as it was)
before=$(git status --porcelain)
step "build_runner" dart run build_runner build
step "gen-l10n" flutter gen-l10n
step "data model doc" dart run tool/gen_data_model.dart --check
step "codegen unchanged" bash -c '[[ "$(git status --porcelain)" == "$1" ]] || { git status --porcelain; exit 1; }' _ "$before"

# 3. schema guard
step "make-migrations" dart run drift_dev make-migrations
step "schema snapshot committed" clean_tree drift_schemas lib/data/db.steps.dart test/drift

# 4. tests + coverage
step "tests (no goldens) + coverage" flutter test --exclude-tags golden --coverage
step "coverage by layer + gates" dart run tool/coverage_report.dart coverage/lcov.info

# 5. goldens
step "goldens" flutter test --tags golden

# 6. security
if command -v gitleaks >/dev/null; then
  base=$(git merge-base HEAD origin/release-packaging 2>/dev/null || echo HEAD~1)
  step "gitleaks (branch diff)" gitleaks git --no-banner --log-opts="$base..HEAD" .
else
  skip "gitleaks" "not installed (go install github.com/zricethezav/gitleaks/v8@latest)"
fi
if command -v osv-scanner >/dev/null; then
  step "osv-scanner (pubspec.lock)" osv-scanner scan --lockfile pubspec.lock
else
  skip "osv-scanner" "not installed (CI downloads v2.0.2, checksum-pinned)"
fi
step "licences (no GPL/AGPL shipped)" dart run tool/check_licenses.dart
if command -v actionlint >/dev/null; then
  step "workflows (actionlint)" actionlint
else
  skip "actionlint" "not installed (go install github.com/rhysd/actionlint/cmd/actionlint@latest)"
fi

# 7. build & package (Linux)
if [[ $PACKAGE == 1 ]]; then
  step "package (tarball, AppImage, RPM, deb, RUNPATH guard)" ./scripts/package_linux.sh
  if command -v rpmlint >/dev/null && ls dist/*.rpm >/dev/null 2>&1; then
    rpmlint -r packaging/rpm/invoice-desk.rpmlintrc dist/*.rpm >"$LOG/rpmlint.txt" 2>&1 || true
    results+=("INFO  rpmlint: $(tail -n 1 "$LOG/rpmlint.txt")")
  fi
  smoke() {
    local t; t=$(mktemp -d)
    local runner=()
    if [[ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
      command -v xvfb-run >/dev/null || { echo "no display and no xvfb-run"; return 1; }
      runner=(xvfb-run -a)
    fi
    INVOICE_DESK_DATA_DIR=$t timeout 10 "${runner[@]}" build/linux/x64/release/bundle/invoice_desk >"$LOG/smoke.log" 2>&1
    cat "$LOG/smoke.log"
    [[ -f "$t/invoice_desk.sqlite" ]] || { echo "database was not created"; return 1; }
    if grep -E "Unhandled Exception|\[ERROR:flutter|Exception caught by" "$LOG/smoke.log"; then return 1; fi
    rm -rf "$t"
    echo "smoke OK (temp data dir, 10 s)"
  }
  step "smoke run" smoke
else
  skip "package + smoke run" "--no-package"
fi
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) step "build windows" flutter build windows --release ;;
  Darwin) step "build macos" flutter build macos --release ;;
  *) skip "build windows/macos" "CI-only (runs on windows-2022 / macos-15)" ;;
esac

printf '\n\033[1m══ ci_local summary ══\033[0m\n'
printf '%s\n' "${results[@]}"
rm -rf "$LOG"
exit $failed
