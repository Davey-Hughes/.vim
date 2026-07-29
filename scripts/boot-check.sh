#!/usr/bin/env bash
# Install every plugin at its locked version, then prove nvim boots clean.
#
# Runs against a COPY of the tracked tree in a scratch dir, with its own XDG
# dirs, so it can neither touch a real plugin install nor rewrite the checked-in
# lazy-lock.json (Lazy writes the lockfile on install).
#
# The gate is STDERR, not the exit code — measured, not assumed. `nvim --headless
# +qa` against a config with a fatal Lua error still exits 0; it just writes the
# E5113 traceback to stderr (479 bytes, in the case this was verified against).
# `Lazy! restore` likewise exits 0 when a plugin's build task fails. So both
# phases below assert on OUTPUT, and treat a zero exit as meaning nothing.
#
# Deliberately NOT checked: whether lazy-lock.json round-trips unchanged. A
# fresh install always omits the lazy.nvim entry (it bootstraps itself by git
# clone before it manages anything), so a strict diff would fail on every run.

set -uo pipefail

repo_root="$(git rev-parse --show-toplevel)"
base="${BOOT_CHECK_DIR:-${TMPDIR:-/tmp}/nvim-boot-check}"

rm -rf "${base:?}"
mkdir -p "$base"/{config/nvim,data,state,cache,home}

# Tracked files as they exist in the WORKING TREE, not as of HEAD — so running
# this locally tests the edits you are about to commit. In CI the two are
# identical, since the checkout has no local modifications.
(cd "$repo_root" && git ls-files -z | tar -cf - --null -T -) | tar -xf - -C "$base/config/nvim"

# HOME is isolated too, and that matters more than it looks. An earlier version
# overrode only the XDG dirs, so a dev box where ~/.vim happens to exist made a
# config hardcoding "$HOME/.vim" pass here and fail in CI, where HOME is /root.
# Cargo is pointed back at the real toolchain so blink.cmp still builds without
# re-downloading the crate registry into a throwaway HOME.
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
export HOME="$base/home"

export XDG_CONFIG_HOME="$base/config"
export XDG_DATA_HOME="$base/data"
export XDG_STATE_HOME="$base/state"
export XDG_CACHE_HOME="$base/cache"

echo "==> installing plugins at locked versions"
if ! nvim --headless "+Lazy! restore" +qa >"$base/install.log" 2>&1; then
  echo "nvim exited non-zero during install" >&2
  tail -40 "$base/install.log" >&2
  exit 1
fi

# Strip lazy's ANSI colouring before matching, or the markers hide inside escapes.
if sed 's/\x1b\[[0-9;]*m//g' "$base/install.log" | grep -qE "Failed task|Error executing|^E[0-9]{3,4}:"; then
  echo "a plugin failed to install or build:" >&2
  sed 's/\x1b\[[0-9;]*m//g' "$base/install.log" | grep -E "Failed task|Error executing|^E[0-9]{3,4}:" >&2
  exit 1
fi

installed=$(find "$base/data/nvim/lazy" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
echo "==> $installed plugins installed"

echo "==> booting"
boot_err="$base/boot.stderr"
# No probe here on purpose: in headless mode vim.print/echo go to STDERR, so any
# "prove it ran" message would trip the empty-stderr assertion below. A clean
# boot of this config writes nothing at all, which is exactly the signal.
nvim --headless +qa 2>"$boot_err"
boot_status=$?

if [ "$boot_status" -ne 0 ]; then
  echo "nvim exited $boot_status on boot" >&2
  cat "$boot_err" >&2
  exit 1
fi

if [ -s "$boot_err" ]; then
  echo "nvim booted but wrote to stderr:" >&2
  cat "$boot_err" >&2
  exit 1
fi

echo "==> config boots clean"
