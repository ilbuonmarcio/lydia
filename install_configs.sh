#!/bin/sh
mkdir ../../.themes/          2> /dev/null

mkdir ../../.scripts          2> /dev/null
mkdir ../../.config/i3        2> /dev/null
mkdir ../../.config/kitty 2> /dev/null
mkdir ../../.config/polybar   2> /dev/null
mkdir ../../.config/gtk-3.0/  2> /dev/null
mkdir ../../.config/compton/  2> /dev/null
mkdir ../../.config/Code\ -\ OSS/ 2> /dev/null
mkdir ../../.config/Code\ -\ OSS/User/ 2> /dev/null
mkdir ../../.config/alacritty 2> /dev/null
mkdir ../../.config/lxpanel/  2> /dev/null
mkdir ../../.config/lxpanel/LXDE/ 2> /dev/null
mkdir ../../.config/lxpanel/LXDE/panels/ 2> /dev/null
mkdir ../../.config/lxsession/ 2> /dev/null
mkdir ../../.config/lxsession/LXDE/ 2> /dev/null

cp -rf ./configs/i3/*         ../../.config/i3/
cp -rf ./configs/kitty/*  ../../.config/kitty/
cp -rf ./configs/polybar/*    ../../.config/polybar/
cp -rf ./configs/zsh/.zshrc   ../../
cp -rf ./configs/compton/* ../../.config/compton/
cp -rf ./configs/Xresources/.Xresources ../../
cp -rf ./configs/vim/.vimrc ../../
cp -rf ./configs/gtk3/settings.ini ../../.config/gtk-3.0/
cp -rf ./scripts/* ../../.scripts/
cp -rf ./configs/code/settings.json ../../.config/Code\ -\ OSS/User/
cp -rf ./configs/alacritty/* ../../.config/alacritty/
cp -f ./configs/lxde/panel ../../.config/lxpanel/LXDE/panels/
cp -f ./configs/lxde/desktop.conf ../../.config/lxsession/LXDE/
cp -rf ./configs/lxde/Nightmare ../../.themes/
cp -rf ./configs/lxde/Stylish ../../.themes/

# installing python spotify plugin interface for polybar module
git clone https://github.com/Jvanrhijn/polybar-spotify &> /dev/null
cp polybar-spotify/spotify_status.py ~/.scripts/
yes | rm -rf polybar-spotify
chmod +x ~/.scripts/spotify_status.py
