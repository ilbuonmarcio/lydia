export ZSH="/home/mrcz/.oh-my-zsh"

ZSH_THEME="pi"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export SHELL=zsh
export PAGER=less
export FILE=ranger
export TERMINAL=alacritty
export EDITOR=vim
export VISUAL=vim
export BROWSER=chromium

# docker aliases and functions
alias dockertop='sudo docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

dsac() { sudo docker stop $(sudo docker ps -a -q); }
dkac() { sudo docker kill $(sudo docker ps -a -q); }
drac() { sudo docker rm $(sudo docker ps -a -q); }
drai() { sudo docker rmi $(sudo docker images -a -q); }

source $HOME/.secrets
