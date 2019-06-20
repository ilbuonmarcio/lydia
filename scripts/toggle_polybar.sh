#!/bin/zsh

echo 
if [ $(pidof polybar | wc -l) = 0 ]; then
	polybar -q example &>/dev/null &
else
	kill -9 $(pidof polybar)
fi
