#!/bin/zsh

echo 
if [ $(pidof polybar | wc -l) = 0 ]; then
	for m in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$m polybar -q -c=$HOME/.config/polybar/topbar topbar &>/dev/null &
	done
else
	kill -9 $(pidof polybar)
fi
