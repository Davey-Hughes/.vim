#!/bin/bash

# link nvim to this directory
mkdir -p $HOME/.config
ln -sfn $HOME/.vim $HOME/.config/nvim

# initialize all submodules
git submodule update --init --recursive

# pull newest changes for each submodule, recursively
git submodule foreach --recursive \
    'eval "case \$name in \
        'pack/fzf/start/fzf-preview.vim') \
            git checkout release/rpc ;; \
        'pack/misc/start/vim-slime') \
            git checkout main ;; \
        'pack/misc/start/copilot.vim') \
            git checkout release ;; \
        'pack/filetypes/start/vim-apl') \
            git checkout main ;; \
        'pack/lsp/opt/goto-preview') \
            git checkout main ;; \
        'pack/misc/opt/nvim-coverage') \
            git checkout main ;; \
        'pack/ui/opt/nvim-numbertoggle') \
            git checkout main ;; \
        *) git checkout master ;; \
    esac"'

git submodule foreach --recursive git pull

# yarn install coc
cd $HOME/.vim/pack/lsp/start/coc.nvim
yarn install

# install coc extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
    echo '{"dependencies":{}}'> package.json
fi
