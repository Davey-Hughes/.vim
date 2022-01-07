# Davey Hughes' .vim

This is my ever-changing vim configuration which includes all the plugins
listed towards the top of the vimrc. The plugins are managed using vim's
built-in package manager and git submodules.

## Installation
After cloning, all the packages can be initialized and later updated by
running:
```
./updsubmod.sh
```
This updates all the plugins and coc, an asynchronous autocompletion engine
that supports the language server protocol (LSP). Currently all packages are
set to always always be used using vim's pack/\*\*\*/start system.

## vimrc
Almost all settings, including plugin specific settings, are located in vimrc. 

## ftplugin
Ideally, most filetype specific settings are located in the relevant
filetype.vim file in after/ftplugin. This allows filetype settings to be
dynamically loaded depending on the filetype of the buffer, which helps with
organization.

## Optional programs
In general, these packages and settings that rely on external executables
should not complain or error if the executable doesn't exist, however in rare
cases they might. Depending on what files are being edited, the following
programs may be useful to have installed.

* linters (ALE)
    * clang
    * ccls
    * clang-tidy
    * flake8
* formatters
    * clang-format
    * autopep8
    * gofmt (comes with go installation)
    * rustfmt
* fzf
* tmux
