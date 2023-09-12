# Davey Hughes' .vim

Plugins are managed using Lazy.nvim, meaning this is an NeoVim only
installation.

## Installation
This updates all the plugins and coc, an asynchronous autocompletion engine
that supports the language server protocol (LSP). Currently all packages are
set to always always be used using vim's pack/\*\*\*/start system.

## vimrc
Settings are located in init.lua, vimrc, and plugin specific settings are in
the `lua/plugins/` directory.

## ftplugin
Ideally, most filetype specific settings are located in the relevant
filetype.vim file in after/ftplugin. This allows filetype settings to be
dynamically loaded depending on the filetype of the buffer, which helps with
organization.
