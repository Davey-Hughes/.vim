#!/usr/bin/env bash
# Run the four static checks that CI runs, against the tracked tree.
#
# CI deliberately runs these as four separate jobs so they go red independently
# and each installs only the one tool it needs. This is the local equivalent for
# a machine that has all four. The boot check is NOT included — it installs 84
# plugins and takes minutes; run scripts/boot-check.sh for that.
#
# A missing tool is reported as SKIP, never passed over silently, and does not by
# itself fail the run — a machine without vint should still be able to commit.
# Only a check that actually ran and failed sets a non-zero exit.
#
# Kept free of bash 4 features (mapfile, associative arrays): a hook invoked by a
# GUI git client can get macOS's /bin/bash 3.2 rather than a homebrew bash.

set -uo pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

failed=0
skipped=""

have() { command -v "$1" >/dev/null 2>&1; }

report() {
  # report NAME STATUS [OUTPUT]
  printf '  %-12s %s\n' "$1" "$2"
  if [ -n "${3:-}" ]; then
    printf '%s\n' "$3" | sed 's/^/      /'
  fi
}

# lua-syntax-check.sh uses luajit when present and falls back to nvim, so either
# one satisfies it.
if have luajit || have nvim; then
  if out=$(./scripts/lua-syntax-check.sh 2>&1); then
    report lua-syntax OK
  else
    report lua-syntax FAIL "$out"
    failed=1
  fi
else
  report lua-syntax SKIP "needs luajit or nvim"
  skipped="$skipped lua-syntax"
fi

if have stylua; then
  if out=$(git ls-files '*.lua' | xargs stylua --check 2>&1); then
    report stylua OK
  else
    report stylua FAIL "$out"
    failed=1
  fi
else
  report stylua SKIP "stylua not installed"
  skipped="$skipped stylua"
fi

if have luacheck; then
  # -q so a failure shows only the offending files, not an OK line per file. CI
  # keeps the verbose form, where the full list is useful in the job log.
  if out=$(git ls-files '*.lua' | xargs luacheck -q 2>&1); then
    report luacheck OK
  else
    report luacheck FAIL "$out"
    failed=1
  fi
else
  report luacheck SKIP "luacheck not installed"
  skipped="$skipped luacheck"
fi

if have vint; then
  if out=$(git ls-files '*.vim' | xargs vint 2>&1); then
    report vint OK
  else
    report vint FAIL "$out"
    failed=1
  fi
else
  report vint SKIP "vint not installed"
  skipped="$skipped vint"
fi

if [ -n "$skipped" ]; then
  printf '\n  not verified locally:%s — CI still runs them\n' "$skipped"
fi

exit "$failed"
