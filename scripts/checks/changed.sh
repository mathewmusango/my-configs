#!/usr/bin/env sh
# Run the local checks against CHANGED files only (pre-commit friendly).
# Whole-repo passes stay in container/checks/compose.yml (which mirrors CI
# exactly); this is the fast feedback loop for the commit stage. Reuses the
# same tool images as container/checks/compose.yml.
#
# Usage:
#   scripts/checks/changed.sh            # staged + unstaged vs HEAD
#   scripts/checks/changed.sh --cached   # staged only (pre-commit hook)
#
# Install as the git pre-commit hook:
#   git config core.hooksPath .githooks

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

if [ "${1:-}" = "--cached" ]; then
  FILES="$(git diff --cached --name-only --diff-filter=ACM)"
else
  FILES="$(git diff --name-only --diff-filter=ACM; git diff --cached --name-only --diff-filter=ACM)"
fi

if [ -z "$FILES" ]; then
  printf '%s⏭  no changed files — nothing to check%s\n' "$YELLOW" "$NC"
  exit 0
fi

SH_FILES="$(printf '%s\n' "$FILES" | grep -E '\.sh$|(^|/)\.githooks/' || true)"
JSONC_FILES="$(printf '%s\n' "$FILES" | grep -E '\.jsonc$|scripts/checks/jsonc\.py$' || true)"

if [ -n "$SH_FILES" ]; then
  printf '%s== shellcheck (changed) ==%s\n' "$BOLD" "$NC"
  # Loop, not xargs: xargs execs a single argv[0], but the podman invocation
  # is several words — it must run through the shell.
  if ! printf '%s\n' "$SH_FILES" | while IFS= read -r f; do
    podman run --rm -v "$ROOT:/repo:ro" -w /repo docker.io/koalaman/shellcheck-alpine shellcheck -S warning "$f"
  done; then
    printf '%s❌ shellcheck failed%s\n' "$RED" "$NC"
    exit 1
  fi
  printf '%s✅ shellcheck passed%s\n' "$GREEN" "$NC"
fi

if [ -n "$JSONC_FILES" ]; then
  # jsonc.py scans the whole repo (no per-file mode) — cheap enough here.
  printf '%s== jsonc (config.jsonc parse) ==%s\n' "$BOLD" "$NC"
  if ! podman run --rm -v "$ROOT:/repo:ro" -w /repo docker.io/library/python:alpine python3 scripts/checks/jsonc.py; then
    printf '%s❌ jsonc failed%s\n' "$RED" "$NC"
    exit 1
  fi
  printf '%s✅ jsonc passed%s\n' "$GREEN" "$NC"
fi

printf '%s✅ changed-files checks passed%s\n' "$GREEN" "$NC"
