# Davey Hughes' .vim

Plugins are managed using Lazy.nvim, meaning this is an NeoVim only
installation.

## vimrc
Settings are located in init.lua, and plugin specific settings are in
the `lua/plugins/` directory.

## ftplugin
Ideally, most filetype specific settings are located in the relevant
filetype.vim file in after/ftplugin. This allows filetype settings to be
dynamically loaded depending on the filetype of the buffer, which helps with
organization.

## Checks
CI (`.forgejo/workflows/ci.yml`) runs five jobs on every push: four static
checks, plus a `boot` job that installs every plugin at its locked version and
asserts nvim starts clean.

Run the static ones locally:

```sh
./scripts/checks.sh
```

A tool that isn't installed is reported as `SKIP` rather than silently passed
over, and doesn't fail the run. To run them before every commit:

```sh
git config core.hooksPath scripts/hooks
```

Bypass it for one commit with `git commit --no-verify`.

The boot check is separate because it installs 84 plugins and takes minutes:

```sh
./scripts/boot-check.sh
```

It works on a copy of the tracked tree under its own `HOME` and XDG dirs, so it
can't touch a real plugin install or rewrite `lazy-lock.json`.

### Two things that will bite you
`stylua.toml` **must stay at the repo root**. conform.nvim invokes stylua with
`--search-parent-directories`, which only walks up from the file being
formatted — a copy under `configs/` is invisible to both conform and CI, and the
two silently disagree about formatting.

`lazy-lock.json` **is tracked**. Commit it when plugins change, or CI installs
different versions than you run. Nothing warns you if it drifts.

## Layout
Paths are derived from `stdpath("config")`, not hardcoded to `~/.vim`, so the
tree works checked out anywhere. Use `$VIMDIR` in Vimscript and
`vim.fn.stdpath("config")` in Lua rather than `$HOME/.vim`.
