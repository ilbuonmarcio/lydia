#!/bin/bash

testing_packages_installed=$(yes n | sudo pacman -Syu 2>&1 | grep 'warning: ' | awk '{ print $2 }' | sed 's/://g' | xargs)
sudo pacman -S $testing_packages_installed
