#!/bin/bash

# powerline
pip install --user powerline-status

git clone https://github.com/powerline/fonts.git --depth=1 --progress
cd fonts
./install.sh
cd ..
rm -rf fonts

mkdir .tmp
cd .tmp
mkdir powerline-shell
git clone https://github.com/milkbikis/powerline-shell
cd .tmp/powerline-shell
./install.py
ln -s "$(pwd)/powerline-shell.py" ~/.powerline-shell.py