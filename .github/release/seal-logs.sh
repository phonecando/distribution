#!/usr/bin/env bash
# Seals a release job's logs (step.sh's) for us: one tarball, encrypted with
# age to the public key in log-key.txt, into <out-dir>, and the plain logs
# deleted. Only the key's owner can read them; the job uploads the sealed
# file as an artifact kept 7 days. With no key in log-key.txt yet the logs
# are deleted unread: they are never uploaded in the clear.
#
# Usage: seal-logs.sh <out-dir>
# Env: RELEASE_LOGS (default $RUNNER_TEMP/release-logs), RELEASE_JOB.
set -euo pipefail
out="${1:?usage: seal-logs.sh <out-dir>}"
here="$(cd "$(dirname "$0")" && pwd)"
logs="${RELEASE_LOGS:-$RUNNER_TEMP/release-logs}"
AGE_VERSION=v1.3.2
declare -A AGE_SHA256=(
  [amd64]=cbe24006683f8eb669266162894b9a522a1af52f2665fbc63a4bb032ed26ac10
  [arm64]=6b8dc4333c53a5a57c9e5834e3a48f92605d7154014cd07269ff3327db5d37f4
)

if [ ! -d "$logs" ]; then
  echo "no logs to seal"
  exit 0
fi
key="$(grep -E '^age1[0-9a-z]+$' "$here/log-key.txt" | head -n 1 || true)"
if [ -z "$key" ]; then
  rm -rf "$logs"
  echo "log-key.txt holds no age public key yet: the logs were deleted, not kept"
  exit 0
fi

case "$(uname -m)" in
  x86_64) arch=amd64 ;;
  aarch64 | arm64) arch=arm64 ;;
  *) echo "no age build for $(uname -m)"; rm -rf "$logs"; exit 1 ;;
esac
tools="$RUNNER_TEMP/age"
tgz="$tools/age-$AGE_VERSION-linux-$arch.tar.gz"
mkdir -p "$tools"
curl -fsSL --retry 3 -o "$tgz" "https://github.com/FiloSottile/age/releases/download/$AGE_VERSION/age-$AGE_VERSION-linux-$arch.tar.gz"
echo "${AGE_SHA256[$arch]}  $tgz" | sha256sum --check --strict --quiet
tar -xzf "$tgz" -C "$tools"

mkdir -p "$out"
sealed="$out/${RELEASE_JOB:-release}-logs.tar.gz.age"
tar -czf - -C "$logs" . | "$tools/age/age" --encrypt --recipient "$key" --output "$sealed"
rm -rf "$logs"
echo "logs sealed: $(basename "$sealed")"
