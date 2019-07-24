#!/bin/bash

# initialize all submodules
git submodule update --init --recursive

# pull newest changes for each submodule, recursively
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull
