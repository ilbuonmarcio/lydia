#!/bin/zsh

xrandr --output DisplayPort-0 --mode 2560x1440 --rate 144 --primary
xrandr --output DisplayPort-1 --mode 2560x1440 --rate 75 --right-of DisplayPort-0

xrandr --output DisplayPort-0 --set TearFree on
xrandr --output DisplayPort-1 --set TearFree on
