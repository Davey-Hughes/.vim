#!/bin/bash

# link nvim to this directory
mkdir -p $HOME/.config
ln -s $HOME/.vim $HOME/.config/nvim

# initialize all submodules
git submodule update --init --recursive

# pull newest changes for each submodule, recursively
git submodule foreach --recursive \
    'eval "case \$name in \
        'bundle/fzf-preview.vim') \
            git checkout release/rpc ;; \
        'bundle/vim-slime') \
            git checkout main ;; \
        *) git checkout master ;; \
    esac"'

git submodule foreach --recursive git pull

# install coc extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
    echo '{"dependencies":{}}'> package.json
fi

# npm install coc-git
npm install coc-git coc-java coc-json coc-pyright coc-go coc-vimlsp coc-fzf-preview coc-rust-analyzer \
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
