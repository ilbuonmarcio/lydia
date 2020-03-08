#!/bin/sh
mkdir ../../.themes/          2> /dev/null
cp -r ./themes/*	      ../../.themes/

mkdir ../../.scripts          2> /dev/null
mkdir ../../.config/i3        2> /dev/null
mkdir ../../.config/alacritty 2> /dev/null
mkdir ../../.config/polybar   2> /dev/null
mkdir ../../.config/gtk-3.0/  2> /dev/null
mkdir ../../.config/compton/  2> /dev/null
mkdir ../../.config/dunst/  2> /dev/null
mkdir ../../.config/Code\ -\ OSS/ 2> /dev/null
mkdir ../../.config/Code\ -\ OSS/User/ 2> /dev/null

cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/alacritty/*  ../../.config/alacritty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/dunst/*    ../../.config/dunst/
cp -rf ./configs/zsh/.zshrc   ../../
cp -rf ./configs/zsh/mrczlnks.zsh-theme ../../.oh-my-zsh/themes/
cp -rf ./configs/compton/* ../../.config/compton/
cp -rf ./configs/Xfiles/.Xresources ../../
cp -rf ./configs/Xfiles/.xinitrc ../../
cp -rf ./configs/vim/.vimrc ../../
cp -rf ./configs/gtk3/settings.ini ../../.config/gtk-3.0/
cp -rf ./scripts/* ../../.scripts/
cp -rf ./configs/code/settings.json ../../.config/Code\ -\ OSS/User/

# installing python spotify plugin interface for polybar module
git clone https://github.com/Jvanrhijn/polybar-spotify &> /dev/null
cp polybar-spotify/spotify_status.py ~/.scripts/
yes | rm -rf polybar-spotify
chmod +x ~/.scripts/spotify_status.py
