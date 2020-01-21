#!/bin/zsh

xrandr --output DisplayPort-2 --mode 2560x1440 --rate 144 --primary
xrandr --output DisplayPort-1 --mode 2560x1440 --rate 75 --left-of DisplayPort-2
