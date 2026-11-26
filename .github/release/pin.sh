#!/usr/bin/env bash
# The phone-control code an app release ships, pinned by the app itself: the
# app's checkout records phonecando/phone-control as its phone-control/
# submodule at one commit, and that commit, already on phone-control's main
# branch (published, so anyone can read the code a release carries), is the
# one the release builds with.
#
#   pin.sh read <app-checkout>
#       the recorded commit, as phone-control=<sha> in $GITHUB_OUTPUT; fails
#       unless phone-control is a submodule there
#   pin.sh verify <app-checkout> <sha>
#       <app-checkout>/phone-control is checked out at <sha>, with main's
#       history fetched, and <sha> is on main
set -euo pipefail
usage="usage: pin.sh read <app-checkout> | pin.sh verify <app-checkout> <sha>"
mode="${1:?$usage}" app="${2:?$usage}"

case "$mode" in
  read)
    entry="$(git -C "$app" ls-tree HEAD phone-control)"
    if [ -z "$entry" ]; then
      echo "::error title=No phone-control::the app's commit has no phone-control entry"
      exit 1
    fi
    read -r kind type sha _ <<< "$entry"
    if [ "$kind" != 160000 ] || [ "$type" != commit ]; then
      echo "::error title=Not a submodule yet::the app's phone-control is a plain folder ($type), not a submodule of phonecando/phone-control"
      exit 1
    fi
    [[ "$sha" =~ ^[0-9a-f]{40}$ ]] || { echo "::error::not a commit id: $sha"; exit 1; }
    echo "the app pins phone-control at $sha"
    if [ -n "${GITHUB_OUTPUT:-}" ]; then echo "phone-control=$sha" >> "$GITHUB_OUTPUT"; fi
    ;;
  verify)
    want="${3:?$usage}"
    dir="$app/phone-control"
    got="$(git -C "$dir" rev-parse HEAD)"
    if [ "$got" != "$want" ]; then
      echo "::error title=Wrong phone-control::checked out $got, the app pins $want"
      exit 1
    fi
    if ! git -C "$dir" merge-base --is-ancestor "$want" origin/main; then
      echo "::error title=Unpublished phone-control::the app pins phone-control at $want, which is not on phonecando/phone-control's main: push it there first"
      exit 1
    fi
    echo "phone-control $want is on main"
    ;;
  *) echo "$usage" >&2; exit 2 ;;
esac
