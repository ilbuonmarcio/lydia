#!/bin/sh
mkdir ../../.config/i3        > /dev/null
mkdir ../../.config/alacritty > /dev/null
mkdir ../../.config/polybar   > /dev/null
mkdir ../../.config/gtk-3.0/  > /dev/null
cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/alacritty/*  ../../.config/alacritty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/zsh/.zshrc   ../../
cp -rf ./configs/Xresources/.Xresources ../../
cp -rf ./configs/vim/.vimrc ../../
cp -rf ./configs/gtk3/settings.ini ../../.config/gtk-3.0/
