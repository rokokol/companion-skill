#!/usr/bin/env bash
# The marker guard: a template's placeholders must not survive into a fork that is being
# used for real. Every placeholder carries a `TEMPLATE:` marker, and this decides which
# state the repository is supposed to be in — then proves, on every run, that it can tell
# the two apart, on throwaway copies with a marker planted and stripped.
#
#   check-template.sh [--template] [DIR]
#
# Default (no flag) is the fork's expectation: NO markers may remain, because a leftover
# placeholder is loaded as part of the persona and read as if somebody had chosen it. A
# fork inherits the workflow verbatim, so it starts red until the placeholders are gone —
# which is the point: forgetting is the failure mode this guards.
#
# --template is the template's own expectation: markers MUST be present, so the template
# cannot quietly rot into a half-filled persona nobody meant to publish.
#
# DIR is the repository (default: the current directory). Exit 1 with `check-template:
# <what>` on the first finding, 2 on a usage error. Nothing here reaches the network.
set -euo pipefail

usage() { sed -n '2,17p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

marker='TEMPLATE:'
want_markers=0
while (($#)); do
  case "$1" in
    --template)
      want_markers=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      usage >&2
      exit 2
      ;;
    *) break ;;
  esac
done
(($# <= 1)) || {
  usage >&2
  exit 2
}
root="${1:-.}"
[[ -d "$root" ]] || {
  echo "check-template: $root is not a directory" >&2
  exit 2
}
root=$(cd -- "$root" && pwd)

fail() {
  echo "check-template: $1" >&2
  exit 1
}

# Only the documents a persona is actually read from — a marker inside this script's own
# help text is not a placeholder, and neither is one in the changelog's history
docs_with_marker() {
  local dir="$1" found=""
  local f
  for f in "$dir/SKILL.md" "$dir/references"/*.md; do
    [[ -f "$f" ]] || continue
    if grep -qF -- "$marker" "$f"; then found="$found ${f#$dir/}"; fi
  done
  printf '%s' "${found# }"
}

verdict() { # verdict DIR -> prints ok/left/none, never fails
  local left
  left=$(docs_with_marker "$1")
  if ((want_markers)); then
    [[ -n "$left" ]] && printf 'ok' || printf 'none'
  else
    [[ -z "$left" ]] && printf 'ok' || printf 'left'
  fi
}

# ---- prove it can fail, before trusting what it says about this repository ------------
# A guard that has never rejected anything is a decoration, so both directions are tried
# on copies each run: one with a marker planted, one with every marker stripped.
tmp=$(mktemp -d "${TMPDIR:-/tmp}/check-template.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/planted/references" "$tmp/stripped/references"
printf '# skill\n\n> %s replace this with the real voice\n' "$marker" > "$tmp/planted/SKILL.md"
printf '# dossier\n\n_(empty)_\n' > "$tmp/planted/references/user.md"
printf '# skill\n\nThe voice, written out properly\n' > "$tmp/stripped/SKILL.md"
printf '# dossier\n\n_(empty)_\n' > "$tmp/stripped/references/user.md"

if ((want_markers)); then
  [[ "$(verdict "$tmp/stripped")" == none ]] ||
    fail "a copy with every marker stripped passed --template — the check cannot catch it"
  [[ "$(verdict "$tmp/planted")" == ok ]] ||
    fail "a copy with a marker was rejected under --template — the check is inverted"
else
  [[ "$(verdict "$tmp/planted")" == left ]] ||
    fail "a copy with a planted marker passed — the check cannot catch it"
  [[ "$(verdict "$tmp/stripped")" == ok ]] ||
    fail "a copy with no markers was rejected — the check is inverted"
fi

# ---- and now the repository itself ----------------------------------------------------
left=$(docs_with_marker "$root")
if ((want_markers)); then
  [[ -n "$left" ]] ||
    fail "no $marker marker anywhere — a template whose placeholders are gone is a persona nobody chose to publish"
  echo "check-template: template intact, markers in:$(printf ' %s' $left), both directions falsified"
else
  [[ -z "$left" ]] || {
    echo "check-template: $marker still in:$(printf ' %s' $left)" >&2
    fail "placeholders survive — they load as part of the persona, so fill them in or delete them (the template itself runs with --template)"
  }
  echo "check-template: no placeholders left, both directions falsified"
fi
