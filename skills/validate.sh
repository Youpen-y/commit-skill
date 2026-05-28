#!/usr/bin/env bash
# validate.sh — Validate a commit message format
set -euo pipefail

if [[ $# -lt 1 || -z "$1" ]]; then
    echo "Usage: validate.sh <commit-message>"
    exit 1
fi

msg="$1"
types="feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert"

first_line="$(printf '%s' "$msg" | head -n 1)"

# 1. Header format checks (ordered by specificity)

# 1a. Check type prefix
if ! printf '%s' "$first_line" | grep -qE "^(${types})(\(|:|!)"; then
    echo "FAIL: type must be one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
    echo "  Got: ${first_line}"
    exit 1
fi

# 1b. Check ': ' separator present
if ! printf '%s' "$first_line" | grep -qE "^(${types})(\([a-z0-9][a-z0-9-]*\))?!?: "; then
    echo "FAIL: missing ': ' separator after type/scope"
    echo "  Got: ${first_line}"
    exit 1
fi

# 1c. Check description not empty
if printf '%s' "$first_line" | grep -qE ": $"; then
    echo "FAIL: description is empty"
    echo "  Got: ${first_line}"
    exit 1
fi

# 1d. Check description starts with lowercase
if printf '%s' "$first_line" | grep -qE ": [A-Z]"; then
    echo "FAIL: description should not start with a capital letter"
    echo "  Got: ${first_line}"
    exit 1
fi

# 1e. Check description does not end with a period (but allow ... and version numbers)
if printf '%s' "$first_line" | grep -qE '[^.]\.$'; then
    echo "FAIL: description should not end with a period"
    echo "  Got: ${first_line}"
    exit 1
fi

# 2. Blank line before body
line_count="$(printf '%s\n' "$msg" | wc -l)"
if [[ "$line_count" -ge 2 ]]; then
    second_line="$(printf '%s' "$msg" | sed -n '2p')"
    if [[ -n "$second_line" ]]; then
        echo "FAIL: blank line required between header and body"
        echo "  Line 2 should be empty, got: ${second_line}"
        exit 1
    fi
fi

# 3. Footer format — only validate lines after a blank line in the body
footer_section=false
body_lines="$(printf '%s\n' "$msg" | tail -n +3)"
while IFS= read -r line; do
    if [[ -z "$line" ]]; then
        footer_section=true
        continue
    fi
    if [[ "$footer_section" == true ]] && ! printf '%s' "$line" | grep -qE '^[A-Za-z][A-Za-z0-9 _-]+( [#:]|: )'; then
        echo "FAIL: footer lines must follow '<Key>: <value>' format"
        echo "  Got: ${line}"
        exit 1
    fi
done <<< "$body_lines"

echo "OK: valid conventional commit message"
exit 0
