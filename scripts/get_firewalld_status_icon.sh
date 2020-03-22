#!/bin/bash

while true; do
    if [[ "$(sudo firewall-cmd --state 2> /dev/null)" == "running" ]]; then
        echo "";
    else
        echo "";
    fi

    sleep 5
done