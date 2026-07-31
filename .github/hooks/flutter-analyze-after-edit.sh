#!/usr/bin/env bash

set -euo pipefail

json_escape() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/}
  value=${value//$'\t'/\\t}
  printf '%s' "$value"
}

payload="$(cat)"
tool_name=""

if [[ "$payload" =~ \"tool_name\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
  tool_name="${BASH_REMATCH[1],,}"
fi

should_analyze=false
case "$tool_name" in
  apply_patch|create_file|delete_file|replace_string_in_file|insert_edit_into_file|editfiles)
    should_analyze=true
    ;;
  *rename*|*move*)
    should_analyze=true
    ;;
esac

if [[ "$should_analyze" != true ]]; then
  printf '{}\n'
  exit 0
fi

if ! command -v flutter >/dev/null 2>&1; then
  printf '%s\n' '{"decision":"block","reason":"flutter is not available, so the required post-edit validation could not run.","hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Make Flutter available on PATH so the workspace hook can run flutter analyze after edits."}}'
  exit 0
fi

output_file="$(mktemp)"
trap 'rm -f "$output_file"' EXIT

if flutter analyze >"$output_file" 2>&1; then
  printf '{}\n'
  exit 0
fi

analyze_output="$(tail -n 120 "$output_file")"
escaped_output="$(json_escape "$analyze_output")"

printf '{"decision":"block","reason":"flutter analyze failed after an edit.","hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"flutter analyze failed after this edit. Resolve the analyzer output before continuing.\\n\\n%s"}}\n' "$escaped_output"