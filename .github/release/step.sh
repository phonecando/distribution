#!/usr/bin/env bash
# One step of the release workflow (release.yml): runs the command with its
# whole output in a log file, never in the public run log, which shows only
# the step's name, passed or failed, and how long it took. The logs are
# sealed for us at the end of each job (seal-logs.sh). Job summaries and the
# job's env and PATH files are out of reach of the command, so nothing it
# prints can land on the run's page; its outputs file stays, for the
# values a later job needs (never secrets).
#
# Usage: step.sh <name> <command> [args...]
# Env: RELEASE_LOGS (default $RUNNER_TEMP/release-logs), RELEASE_JOB (a
#   prefix for the log's name).
set -uo pipefail
name="${1:?usage: step.sh <name> <command> [args...]}"
shift
logs="${RELEASE_LOGS:-$RUNNER_TEMP/release-logs}"
mkdir -p "$logs"
log="$logs/${RELEASE_JOB:+$RELEASE_JOB-}$name.log"
export RELEASE_LOGS="$logs"
started=$SECONDS
env -u GITHUB_STEP_SUMMARY -u GITHUB_ENV -u GITHUB_PATH "$@" > "$log" 2>&1
status=$?
took=$((SECONDS - started))
if [ "$status" -eq 0 ]; then
  echo "$name: passed (${took}s)"
else
  echo "$name: failed (${took}s, exit $status; the sealed logs have its output)"
fi
exit "$status"
