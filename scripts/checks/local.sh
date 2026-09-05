#!/usr/bin/env sh
# One entry point for the local (stage-1) checks — a thin driver over the
# container/checks/compose.yml services. Portable: no host tool installs (the
# images mirror the CI tools exactly). Default: run every surface whose files
# changed (diff-gated, mirroring the CI checks skip-model). --full runs all
# surfaces unconditionally (use for a first run / fresh clone).
#
# Usage:
#   scripts/checks/local.sh                    # all surfaces, changed files only
#   scripts/checks/local.sh --full             # all surfaces, whole repo
#   scripts/checks/local.sh shell jsonc        # selected surfaces, changed only
#
# Surface names match the container/checks/compose.yml services:
#   jsonc · shell · yaml-actionlint · yaml-syntax
#
# Pre-commit per-file fast path: scripts/checks/changed.sh (install via
# `git config core.hooksPath .githooks`).

set -eu

# shellcheck disable=SC1007  # CDPATH= cd is the intentional empty-CD cd idiom
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
cd "$ROOT"

# Colors only when stdout is a TTY (pipes/logs stay plain).
if [ -t 1 ]; then
  ESC=$(printf '\033')
  BOLD="${ESC}[1m"; GREEN="${ESC}[32m"; YELLOW="${ESC}[33m"; RED="${ESC}[31m"; NC="${ESC}[0m"
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; NC=""
fi

# --- CLI ---------------------------------------------------------------------
MODE="diff"   # diff | full
SURFACES=""
for arg in "$@"; do
  case "$arg" in
    --full) MODE="full" ;;
    --diff) MODE="diff" ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) SURFACES="$SURFACES $arg" ;;
  esac
done

ALL="jsonc shell yaml-actionlint yaml-syntax"
if [ -z "$SURFACES" ]; then
  SURFACES="$ALL"
fi

# --- Changed files (diff mode) ----------------------------------------------
# Whole branch vs origin/main when it exists (PR-shaped), else vs HEAD;
# plus any staged/unstaged working-tree changes on top.
changed_files() {
  if git rev-parse --verify --quiet origin/main >/dev/null; then
    git diff --name-only --diff-filter=ACM origin/main...HEAD
  fi
  git diff --name-only --diff-filter=ACM
  git diff --cached --name-only --diff-filter=ACM
}

if [ "$MODE" = "diff" ]; then
  CHANGED="$(changed_files | sort -u)"
fi

# --- Surface → changed-file globs (mirror the CI checks filters) -------------
surface_touched() {
  # $1 = surface name; reads $CHANGED on stdin
  case "$1" in
    jsonc)            grep -qE '\.jsonc$|scripts/checks/jsonc\.py$' || return 1 ;;
    shell)            grep -qE '\.sh$|(^|/)\.githooks/' || return 1 ;;
    yaml-actionlint|yaml-syntax) grep -qE '\.ya?ml$' || return 1 ;;
  esac
}

# --- Run ---------------------------------------------------------------------
status=0
for svc in $SURFACES; do
  if [ "$MODE" = "diff" ]; then
    if ! printf '%s\n' "$CHANGED" | surface_touched "$svc"; then
      printf '%s⏭  skip: %s (no matching files changed)%s\n' "$YELLOW" "$svc" "$NC"
      continue
    fi
    reason="changed"
  else
    reason="full"
  fi

  printf '%s== %s (%s) ==%s\n' "$BOLD" "$svc" "$reason" "$NC"
  if podman-compose -f container/checks/compose.yml run --rm "$svc"; then
    printf '%s✅ %s (%s) passed%s\n' "$GREEN" "$svc" "$reason" "$NC"
  else
    printf '%s❌ %s (%s) failed%s\n' "$RED" "$svc" "$reason" "$NC"
    status=1
  fi
done

if [ "$MODE" = "diff" ] && [ -z "${CHANGED:-}" ]; then
  printf '%s⏭  no changed files detected — nothing to check (use --full for a whole-repo pass)%s\n' "$YELLOW" "$NC"
fi

if [ "$status" -eq 0 ]; then
  printf '%s✅ all checks passed%s\n' "$GREEN" "$NC"
else
  printf '%s❌ some checks failed%s\n' "$RED" "$NC"
fi
exit "$status"
