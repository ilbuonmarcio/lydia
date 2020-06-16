export ZSH="/home/mrcz/.oh-my-zsh"

ZSH_THEME="mrczlnks"

plugins=(git extract pip python sudo docker docker-compose)

source $ZSH/oh-my-zsh.sh

export SHELL=zsh
export PAGER=less
export FILE=ranger
export TERMINAL=kitty
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox

export WEATHER_PLACE=Verona

export GPG_TTY=$(tty)

export ANDROID_HOME=~/Android/Sdk/
export ANDROID_SDK_ROOT=~/Android/Sdk/

autoload -Uz compinit promptinit
compinit
promptinit

alias vim='nvim'
alias l='ls -lah --color=auto --group-directories-first'
alias updateall="day=$((($(date +%s) - $(date -d $(sed -n '/upgrade$/x;${x;s/.\([0-9-]*\).*/\1/p}' /var/log/pacman.log) +%s)) / 86400)); printf 'Last system update was %d days ago\n' $day; yay -Syu --needed --devel"
alias tpkgl="pacman -Sl | grep '^testing' | grep '\[installed\]$' | awk '{print \$2,\$3}'"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias showpalette="msgcat --color=test | head -n 11 | tail -n 10"

# docker aliases and functions
alias dockertop='sudo docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

dsac() { sudo docker stop $(sudo docker ps -a -q); }
dkac() { sudo docker kill $(sudo docker ps -a -q); }
drac() { sudo docker rm $(sudo docker ps -a -q); }
drai() { sudo docker rmi $(sudo docker images -a -q); }

alias tree='tree -a -I .git'

findtext() {
    grep -Rn "$1" $2
}

findtextfn() {
    grep -Rl "$1" $2
}

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.secrets

path+=("$HOME/.scripts")
path+=("$HOME/Android/Sdk/cmdline-tools/latest/bin/")
export PATH
