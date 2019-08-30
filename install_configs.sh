#!/bin/sh
mkdir ../../.scripts          2> /dev/null
mkdir ../../.config/i3        2> /dev/null
mkdir ../../.config/kitty 2> /dev/null
mkdir ../../.config/polybar   2> /dev/null
mkdir ../../.config/gtk-3.0/  2> /dev/null
cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/kitty/*  ../../.config/kitty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/zsh/.zshrc   ../../
cp -rf ./configs/Xresources/.Xresources ../../
cp -rf ./configs/vim/.vimrc ../../
cp -rf ./configs/gtk3/settings.ini ../../.config/gtk-3.0/
cp -rf ./scripts/* ../../.scripts/
