#!/bin/sh
mkdir ../../.themes/          2> /dev/null

mkdir ../../.scripts          2> /dev/null
mkdir ../../.config/i3        2> /dev/null
mkdir ../../.config/kitty 2> /dev/null
mkdir ../../.config/polybar   2> /dev/null
mkdir ../../.config/gtk-3.0/  2> /dev/null
mkdir ../../.config/picom/  2> /dev/null
mkdir ../../.config/dunst/  2> /dev/null
mkdir ../../.config/Code\ -\ OSS/ 2> /dev/null
mkdir ../../.config/Code\ -\ OSS/User/ 2> /dev/null
mkdir ../../.config/rofi/ 2> /dev/null
mkdir ../../.config/nvim/ 2> /dev/null

cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/kitty/*  ../../.config/kitty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/dunst/*    ../../.config/dunst/
cp -rf ./configs/zsh/.zshrc   ../../
cp -rf ./configs/zsh/mrczlnks.zsh-theme ../../.oh-my-zsh/themes/
cp -rf ./configs/picom/* ../../.config/picom/
cp -rf ./configs/Xfiles/.Xresources ../../
cp -rf ./configs/Xfiles/.xinitrc ../../
cp -rf ./configs/nvim/init.vim ../../.config/nvim/
cp -rf ./configs/gtk3/settings.ini ../../.config/gtk-3.0/
cp -rf ./scripts/* ../../.scripts/
cp -rf ./configs/code/settings.json ../../.config/Code/User/
cp -rf ./configs/gtk2/.gtkrc-2.0 ../../
cp -rf ./configs/rofi/* ../../.config/rofi/

# installing python spotify plugin interface for polybar module
git clone https://github.com/Jvanrhijn/polybar-spotify &> /dev/null
cp polybar-spotify/spotify_status.py ~/.scripts/
yes | rm -rf polybar-spotify
chmod +x ~/.scripts/spotify_status.py
