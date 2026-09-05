#!/usr/bin/env sh
# Local mirror of the CI checks (.github/workflows/checks/{jsonc,shell,yml}.yml)
# — run before committing: sh scripts/check_local.sh
# Keep the commands IDENTICAL to the workflows so green locally = green in CI.
set -e

cd "$(dirname "$0")/.."

echo "== jsonc: parse config.jsonc files"
python3 scripts/check_jsonc.py

echo "== jsonc: design folders ship config.jsonc + screenshot.png"
if ls fastfetch/*/ >/dev/null 2>&1; then
    for d in fastfetch/*/; do
        if [ ! -f "$d/config.jsonc" ] || [ ! -f "$d/screenshot.png" ]; then
            echo "incomplete design: $d"
            exit 1
        fi
    done
    echo "all designs complete"
else
    echo "no fastfetch designs — skipping"
fi

echo "== shell: shellcheck every *.sh"
find . -path './.git' -prune -o -type f -name '*.sh' -print0 2>/dev/null | xargs -0 -r shellcheck -S warning

echo "== yaml: syntax-parse every yml/yaml"
find . -path './.git' -prune -o -type f \( -name '*.yml' -o -name '*.yaml' \) -print 2>/dev/null | while IFS= read -r f; do
    ruby -ryaml -e "YAML.load_file(ARGV[0])" "$f"
    echo "ok: $f"
done

echo "== yaml: actionlint on workflows"
actionlint -no-color .github/workflows/*.yml .github/workflows/checks/*.yml

echo "all checks passed"
