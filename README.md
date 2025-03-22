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
