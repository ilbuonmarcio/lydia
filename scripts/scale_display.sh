#!/bin/sh

selected_display=$(xrandr -q | grep ' con' | awk '{ print $1 }' | fzf)
resolution=$(printf "1280x720\n1600x900\n1920x1080\n2560x1080\n2560x1440\n3440x1440\n3840x2160" | fzf)

xrandr --output $selected_display --scale-from $resolution --panning $resolution
