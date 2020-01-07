#!/bin/zsh

xrandr --output DisplayPort-0 --mode 2560x1440 --rate 144 --primary
xrandr --output HDMI-A-0 --mode 2560x1440 --rate 75 --left-of DisplayPort-0
