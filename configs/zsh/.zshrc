export ZSH="/home/mrcz/.oh-my-zsh"

ZSH_THEME="pi"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export SHELL=zsh
export PAGER=less
export FILE=ranger
export TERMINAL=kitty
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox

autoload -Uz compinit promptinit
compinit
promptinit

# docker aliases and functions
alias dockertop='sudo docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

dsac() { sudo docker stop $(sudo docker ps -a -q); }
dkac() { sudo docker kill $(sudo docker ps -a -q); }
drac() { sudo docker rm $(sudo docker ps -a -q); }
drai() { sudo docker rmi $(sudo docker images -a -q); }

alias tree='tree -a -I .git'

findtext() {
    grep -R "$1" $2
}

findtextfn() {
    grep -Rl "$1" $2
}

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.secrets

path+=("$HOME/.scripts")
export PATH

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx
fi
