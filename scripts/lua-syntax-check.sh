#!/usr/bin/env bash
# Parse every tracked Lua file without executing it.
#
# Catches the "typo'd a comma, nvim won't start" class of bug. Prefers a bare
# luajit (what CI installs) and falls back to nvim's embedded one, so the
# accepted syntax always matches the LuaJIT dialect that loads this config.

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

checker="$repo_root/scripts/parse-check.lua"

if command -v luajit >/dev/null 2>&1; then
  run_checker() { luajit "$checker" "$1"; }
elif command -v nvim >/dev/null 2>&1; then
  run_checker() { nvim --clean --headless -l "$checker" "$1"; }
else
  echo "need luajit or nvim on PATH" >&2
  exit 2
fi

status=0
while IFS= read -r file; do
  if ! err=$(run_checker "$file" 2>&1); then
    printf 'SYNTAX FAIL: %s\n%s\n' "$file" "$err" >&2
    status=1
  fi
done < <(git ls-files '*.lua')

if [ "$status" -eq 0 ]; then
  echo "All tracked Lua files parse cleanly."
fi

exit "$status"
