#!/bin/zsh

if [[ "$(systemctl is-active firewalld.service)" == "active" ]]; then
    dunstify --timeout=2000 --urgency=CRITICAL "Shutting down firewall..."
    sudo systemctl stop firewalld.service
    dunstify --timeout=2000 --urgency=CRITICAL "Firewall shut down!"
else
    dunstify --timeout=2000 --urgency=CRITICAL "Starting firewall..."
    sudo systemctl start firewalld.service
    dunstify --timeout=2000 --urgency=CRITICAL "Firewall started!"
fi
