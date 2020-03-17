#!/bin/zsh

yay -Sy > /dev/null
updates_available=$(yay -Qu --needed --devel)

if [[ $updates_available ]]; then
    num_updates=$(echo $updates_available | wc -l)
    echo "There are $num_updates packages available for update:"
    echo ""
    echo "$updates_available"
else
    echo "Your system is up to date"
fi
