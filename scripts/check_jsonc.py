#!/usr/bin/env python3
"""Parse every config.jsonc in the repo as JSON (JSONC = JSON + comments)."""
import glob
import json
import re
import sys


def strip_jsonc(s: str) -> str:
    """Remove // and /* */ comments, keeping those inside strings intact."""
    out: list[str] = []
    i, n = 0, len(s)
    in_str = False
    esc = False
    while i < n:
        c = s[i]
        if in_str:
            out.append(c)
            if esc:
                esc = False
            elif c == "\\":
                esc = True
            elif c == '"':
                in_str = False
            i += 1
        elif c == '"':
            in_str = True
            out.append(c)
            i += 1
        elif c == "/" and i + 1 < n and s[i + 1] == "/":
            while i < n and s[i] != "\n":
                i += 1
        elif c == "/" and i + 1 < n and s[i + 1] == "*":
            i += 2
            while i + 1 < n and not (s[i] == "*" and s[i + 1] == "/"):
                i += 1
            i += 2
        else:
            out.append(c)
            i += 1
    return "".join(out)


def main() -> int:
    ok = True
    for f in sorted(glob.glob("**/config.jsonc", recursive=True)):
        try:
            raw = open(f, encoding="utf-8").read()
            cleaned = re.sub(r",(\s*[}\]])", r"\1", strip_jsonc(raw))
            json.loads(cleaned)
            print(f"ok: {f}")
        except Exception as e:  # noqa: BLE001 - report any parse failure
            ok = False
            print(f"FAIL: {f}: {e}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
