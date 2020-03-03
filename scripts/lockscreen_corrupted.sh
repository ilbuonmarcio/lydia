#!/bin/sh

maim -m 1 $HOME/.lockscreen_image.png
corrupter $HOME/.lockscreen_image.png $HOME/.lockscreen_image.png
i3lock --image $HOME/.lockscreen_image.png
