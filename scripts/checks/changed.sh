#!/usr/bin/env sh
# Run the local checks against CHANGED files only (pre-commit friendly).
# Whole-repo passes stay in compose/checks/compose.yml (which mirrors CI
# exactly); this is the fast feedback loop for the commit stage. Reuses the
# same tool images as compose/checks/compose.yml.
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

if [ "${1:-}" = "--cached" ]; then
  FILES="$(git diff --cached --name-only --diff-filter=ACM)"
else
  FILES="$(git diff --name-only --diff-filter=ACM; git diff --cached --name-only --diff-filter=ACM)"
fi

if [ -z "$FILES" ]; then
  echo "no changed files — nothing to check"
  exit 0
fi

SH_FILES="$(printf '%s\n' "$FILES" | grep -E '\.sh$|(^|/)\.githooks/' || true)"
JSONC_FILES="$(printf '%s\n' "$FILES" | grep -E '\.jsonc$|scripts/checks/jsonc\.py$' || true)"

if [ -n "$SH_FILES" ]; then
  echo "== shellcheck (changed) =="
  # Loop, not xargs: xargs execs a single argv[0], but the podman invocation
  # is several words — it must run through the shell.
  printf '%s\n' "$SH_FILES" | while IFS= read -r f; do
    podman run --rm -v "$ROOT:/repo:ro" -w /repo docker.io/koalaman/shellcheck-alpine shellcheck -S warning "$f"
  done
fi

if [ -n "$JSONC_FILES" ]; then
  # jsonc.py scans the whole repo (no per-file mode) — cheap enough here.
  echo "== jsonc (config.jsonc parse) =="
  podman run --rm -v "$ROOT:/repo:ro" -w /repo docker.io/library/python:alpine python3 scripts/checks/jsonc.py
fi

echo "changed-files checks passed"
