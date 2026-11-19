#!/usr/bin/env bash
# Installs apt packages on a CI runner with time limits and retries, so a
# stalled or slow Ubuntu mirror fails or recovers in minutes instead of
# hanging the job (docs/worklog/REL-02.md):
#   scripts/apt_retry.sh <package>…
# - apt-get update: up to APT_TRIES (3) tries, APT_UPDATE_LIMIT (90) s each;
# - apt-get install -y --download-only <package>…: up to APT_TRIES tries,
#   APT_DOWNLOAD_LIMIT (300) s each. apt resumes partial downloads from
#   /var/cache/apt/archives/partial, so each try makes progress;
# - apt-get install -y <package>…: once, from the cache, APT_INSTALL_LIMIT
#   (300) s. Not retried: a try killed while dpkg runs leaves "dpkg was
#   interrupted" and every later try fails.
# A ::warning:: is printed per failed try. Worst case with the defaults is
# 3 × 100 + 3 × 310 + 310 s ≈ 26 min, inside the 40/45-minute jobs that call it.
# Both pass -o Acquire::Retries=3 -o Acquire::http::Timeout=30. Output goes
# straight to the job log. Uses sudo unless run as root.
set -euo pipefail

[[ $# -gt 0 ]] || { echo "usage: $0 <package>…" >&2; exit 2; }
tries="${APT_TRIES:-3}"
update_limit="${APT_UPDATE_LIMIT:-90}"
download_limit="${APT_DOWNLOAD_LIMIT:-300}"
install_limit="${APT_INSTALL_LIMIT:-300}"
sudo=(); [[ "$(id -u)" -eq 0 ]] || sudo=(sudo)
apt=(env DEBIAN_FRONTEND=noninteractive apt-get
  -o Acquire::Retries=3 -o Acquire::http::Timeout=30 -o Dpkg::Use-Pty=0)

why() { if [[ $1 -eq 124 || $1 -eq 137 ]]; then echo "timed out after $2 s"; else echo "failed (exit $1)"; fi; }

# retry <label> <tries> <limit> <apt-get arguments…>
retry() {
  local label="$1" n="$2" limit="$3"; shift 3
  local i rc=0
  for ((i = 1; i <= n; i++)); do
    echo "==> ${label}, try ${i}/${n} (limit ${limit} s)"
    rc=0
    timeout -k 10 "${limit}" "${sudo[@]}" "${apt[@]}" "$@" </dev/null || rc=$?
    [[ ${rc} -eq 0 ]] && return 0
    [[ ${i} -lt ${n} ]] && echo "::warning::${label} try ${i}/${n} $(why "${rc}" "${limit}")"
  done
  echo "::error::${label} $(why "${rc}" "${limit}") (try ${n}/${n})"
  exit 1
}

retry "apt-get update" "${tries}" "${update_limit}" update
retry "apt-get install --download-only $*" "${tries}" "${download_limit}" install -y --download-only "$@"
retry "apt-get install -y $*" 1 "${install_limit}" install -y "$@"
