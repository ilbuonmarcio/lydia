#!/bin/zsh

if [[ "$(systemctl is-active firewalld.service)" == "active" ]]; then
    sudo systemctl stop firewalld.service
else
    sudo systemctl start firewalld.service
fi