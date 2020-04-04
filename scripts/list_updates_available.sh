#!/bin/zsh

yay -Sy > /dev/null
num_updates=$(yay -Qu --needed --devel | wc -l)

if [[ "$num_updates" != "0" ]]; then
    echo "There are $num_updates packages available for update"
else
    echo "Your system is up to date"
fi
