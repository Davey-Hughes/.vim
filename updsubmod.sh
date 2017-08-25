#!/bin/bash

# pull newest changes for each submodule, recursively
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull

# change YouCompleteMe submodules to expected versions
cd ./bundle/YouCompleteMe
git submodule update --init --recursive
