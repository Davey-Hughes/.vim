#!/bin/bash

# initialize all submodules
git submodule update --init --recursive

# pull newest changes for each submodule, recursively
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull

# update coc
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz|tar xzfv -

# install coc extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
    echo '{"dependencies":{}}'> package.json
fi

# npm install coc-git
npm install coc-git coc-java coc-json coc-python coc-vimlsp \
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
