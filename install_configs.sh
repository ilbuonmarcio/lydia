#!/bin/sh
mkdir ../../.themes/          2> /dev/null

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
cp -rf ./configs/gtk2/.gtkrc-2.0 ../../

# installing Breeze-Gently theme directly from source
wget -O $HOME/Downloads/Breeze-Gently.zip https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1ODM2MDYzMzkiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjFkNzdmYzJhZTc3OWM4YjdkOGZlYTFmMmRjOTE2OTc5YmM3NmE1MTQzMTZkMzA5MmMyOTYxODU0MTkyN2MxMTM5ZjMxNTRiMDllZDRhODI3MzExNzJiNTcxM2FkYWYxZGY3OTI2YjE2YWQ5NWQ0MjdiYjNjOWZjOGM2ZmU5NjAyIiwidCI6MTU4NDQyNTE4Nywic3RmcCI6IjQ5ZWQ1ZWEyOGYxYTU4ZWI2YzRjYzJjNjg0YzUxZDM5Iiwic3RpcCI6IjIuNDIuMC4yMTMifQ.l2eYFLYDSiiscZY7PGpGyPX4TTZEd4384AeaG9LswqU/Breeze-Gently.zip
unzip -d $HOME/Downloads/ $HOME/Downloads/Breeze-Gently.zip
cp -R $HOME/Downloads/Breeze-Gently/ $HOME/.themes/
rm -rf $HOME/Downloads/Breeze*

# installing python spotify plugin interface for polybar module
git clone https://github.com/Jvanrhijn/polybar-spotify &> /dev/null
cp polybar-spotify/spotify_status.py ~/.scripts/
yes | rm -rf polybar-spotify
chmod +x ~/.scripts/spotify_status.py
