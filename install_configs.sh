#!/bin/sh
mkdir ../../.config/i3        > /dev/null
mkdir ../../.config/alacritty > /dev/null
mkdir ../../.config/polybar   > /dev/null
cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/alacritty/*  ../../.config/alacritty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/zsh/.zshrc   ../../
