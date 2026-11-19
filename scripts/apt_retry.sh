#!/usr/bin/env bash
# Installs apt packages on a CI runner with time limits and retries, so a
# stalled Ubuntu mirror fails or recovers in minutes instead of hanging the
# job (docs/worklog/REL-02.md):
#   scripts/apt_retry.sh <package>…
# - apt-get update: up to APT_TRIES (3) tries, APT_UPDATE_LIMIT (90) s each,
#   with a ::warning:: per failed try;
# - apt-get install -y <package>…: one try, APT_INSTALL_LIMIT (600) s.
# Both pass -o Acquire::Retries=3 -o Acquire::http::Timeout=30. Output goes
# straight to the job log. Uses sudo unless run as root.
set -euo pipefail

[[ $# -gt 0 ]] || { echo "usage: $0 <package>…" >&2; exit 2; }
tries="${APT_TRIES:-3}"
update_limit="${APT_UPDATE_LIMIT:-90}"
install_limit="${APT_INSTALL_LIMIT:-600}"
sudo=(); [[ "$(id -u)" -eq 0 ]] || sudo=(sudo)
apt=(env DEBIAN_FRONTEND=noninteractive apt-get
  -o Acquire::Retries=3 -o Acquire::http::Timeout=30 -o Dpkg::Use-Pty=0)

why() { if [[ $1 -eq 124 || $1 -eq 137 ]]; then echo "timed out after $2 s"; else echo "failed (exit $1)"; fi; }

ok=0
for ((i = 1; i <= tries; i++)); do
  echo "==> apt-get update, try ${i}/${tries} (limit ${update_limit} s)"
  rc=0
  timeout -k 10 "${update_limit}" "${sudo[@]}" "${apt[@]}" update </dev/null || rc=$?
  if [[ ${rc} -eq 0 ]]; then ok=1; break; fi
  echo "::warning::apt-get update try ${i}/${tries} $(why "${rc}" "${update_limit}")"
done
[[ ${ok} -eq 1 ]] || { echo "::error::apt-get update failed ${tries} times"; exit 1; }

echo "==> apt-get install -y $* (limit ${install_limit} s)"
rc=0
timeout -k 10 "${install_limit}" "${sudo[@]}" "${apt[@]}" install -y "$@" </dev/null || rc=$?
[[ ${rc} -eq 0 ]] || { echo "::error::apt-get install $(why "${rc}" "${install_limit}")"; exit 1; }
