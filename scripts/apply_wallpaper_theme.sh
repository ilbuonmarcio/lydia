#!/bin/zsh

if [[ -f "$HOME/.currwall" ]]; then
	wal -i $(cat $HOME/.currwall) --saturate 1 -q -e
fi

