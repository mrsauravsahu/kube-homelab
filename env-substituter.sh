#!/usr/bin/env bash
# env-substituter.sh - fill {secret:NAME} placeholders in YAML files from one secrets file.
#
# Secrets live in ONE file at the repo root: secrets.yaml (gitignored).
# Copy secrets.example.yaml to secrets.yaml and fill it in.
# An environment variable with the same NAME overrides the file (handy in CI).
#
# Usage:
#   ./env-substituter.sh FILE...    render each FILE to FILE.local.yaml next to it
#   ./env-substituter.sh --list     list every placeholder in the repo (file:line:NAME)
#   ./env-substituter.sh --check    check secrets.example.yaml and secrets.yaml cover every placeholder
#
# Placeholder syntax: {secret:NAME}, NAME = [A-Z0-9_]+ (use APP__FIELD, e.g. KEYCLOAK__DB_PASSWORD).
# Find all of them with:  git grep -n '{secret:'
#
# secrets.yaml format: a flat map, one `NAME: value` per line. Values may be bare,
# 'single-quoted' or "double-quoted" (no escape sequences). Comments start with #.
# Set SECRETS_FILE to read a different file.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="${SECRETS_FILE:-$ROOT_DIR/secrets.yaml}"
EXAMPLE_FILE="$ROOT_DIR/secrets.example.yaml"
PLACEHOLDER_RE='\{secret:[A-Z0-9_]+\}'

declare -A SECRETS=()

# Parse a flat `NAME: value` YAML file into the SECRETS array.
load_secrets() {
    local file="$1" line key value n=0
    [[ -f "$file" ]] || { echo "Error: secrets file not found: $file" >&2; echo "  cp secrets.example.yaml secrets.yaml and fill it in" >&2; exit 1; }
    while IFS= read -r line || [[ -n "$line" ]]; do
        n=$((n + 1))
        [[ "$line" =~ ^[[:space:]]*(#.*)?$ ]] && continue
        if [[ "$line" =~ ^([A-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            if [[ "$value" =~ ^\"(.*)\"[[:space:]]*(#.*)?$ ]] || [[ "$value" =~ ^\'(.*)\'[[:space:]]*(#.*)?$ ]]; then
                value="${BASH_REMATCH[1]}"
            else
                value="${value%%[[:space:]]#*}"            # strip trailing comment
                value="${value%"${value##*[![:space:]]}"}"  # strip trailing spaces
            fi
            SECRETS["$key"]="$value"
        else
            echo "Error: $file:$n: expected 'NAME: value' with NAME in [A-Z0-9_]" >&2
            exit 1
        fi
    done < "$file"
}

# Value for NAME: environment first, then secrets file. Empty counts as missing.
lookup() {
    local name="$1"
    if [[ -n "${!name:-}" ]]; then
        printf '%s' "${!name}"
    elif [[ -n "${SECRETS[$name]:-}" ]]; then
        printf '%s' "${SECRETS[$name]}"
    else
        return 1
    fi
}

list_placeholders() {
    git -C "$ROOT_DIR" grep --untracked -nIoE "$PLACEHOLDER_RE" -- . ':!env-substituter.sh' ':!secrets.example.yaml' ':!*.md' \
        | sed -E 's/\{secret:([A-Z0-9_]+)\}$/\1/'
}

check() {
    local names errors=0 name
    names="$(list_placeholders | awk -F: '{print $NF}' | sort -u)"
    load_secrets "$EXAMPLE_FILE"
    for name in $names; do
        [[ -v "SECRETS[$name]" ]] || { echo "Missing from secrets.example.yaml: $name"; errors=$((errors + 1)); }
    done
    for name in "${!SECRETS[@]}"; do
        grep -qx "$name" <<<"$names" || echo "Unused in secrets.example.yaml (no placeholder): $name"
    done
    if [[ -f "$SECRETS_FILE" ]]; then
        SECRETS=()
        load_secrets "$SECRETS_FILE"
        for name in $names; do
            lookup "$name" >/dev/null || echo "No value yet in $(basename "$SECRETS_FILE"): $name"
        done
    else
        echo "Note: $SECRETS_FILE not found; skipped value check"
    fi
    [[ $errors -eq 0 ]] && echo "OK: $(wc -w <<<"$names") placeholder(s) listed in secrets.example.yaml"
    return $errors
}

render() {
    local input="$1" dir base output line name value missing=0
    dir="$(cd "$(dirname "$input")" && pwd)"
    base="$(basename "$input")"
    output="$dir/${base%.*}.local.${base##*.}"

    if ! grep -qE "$PLACEHOLDER_RE" "$input"; then
        echo "Skip (no placeholders): $input"
        return 0
    fi

    for name in $(grep -oE "$PLACEHOLDER_RE" "$input" | sed -E 's/\{secret:(.*)\}/\1/' | sort -u); do
        if ! lookup "$name" >/dev/null; then
            echo "Error: no value for $name ($input:$(grep -nF "{secret:$name}" "$input" | head -1 | cut -d: -f1))" >&2
            missing=$((missing + 1))
        fi
    done
    [[ $missing -eq 0 ]] || return 1

    : > "$output"
    chmod 600 "$output"
    while IFS= read -r line || [[ -n "$line" ]]; do
        while [[ "$line" =~ \{secret:([A-Z0-9_]+)\} ]]; do
            name="${BASH_REMATCH[1]}"
            value="$(lookup "$name")"
            # Quoted replacement so '&' and '\' in values are kept literally.
            line="${line//"{secret:$name}"/"$value"}"
        done
        printf '%s\n' "$line"
    done < "$input" > "$output"
    echo "Rendered: $input -> $output"
}

case "${1:-}" in
    --list) list_placeholders ;;
    --check) check ;;
    ""|-h|--help) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//' ;;
    *)
        load_secrets "$SECRETS_FILE"
        failed=0
        for f in "$@"; do
            [[ -f "$f" ]] || { echo "Error: not a file: $f" >&2; failed=1; continue; }
            render "$f" || failed=1
        done
        exit $failed
        ;;
esac
