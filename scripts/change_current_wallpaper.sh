#!/bin/zsh

echo "$HOME/Pictures/wallpapers/$(ls $HOME/Pictures/wallpapers/ | shuf -n 1)" > $HOME/.currwall

