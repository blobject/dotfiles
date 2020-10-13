[[ $- != *i* ]] && return

## settings
stty -ixon

## functions
0gitbr()
{ git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'; }

## variables
HISTCONTROL=ignoreboth
HISTFILESIZE=65536
HISTSIZE=65536
PS1='\[\033[1;37m\]\t \[\033[0;33m\]'"\$(0gitbr)"'\[\033[1;31m\]\w\[\033[0m\] '
export PATH="$HOME/bin:$HOME/.local/bin${PATH:+:}$PATH"
export LESS=-iRS
export SSH_AUTH_SOCK="$HOME/.ssh/agent"
eval $(dircolors --sh)

## services
if ! pgrep -u $USER ssh-agent >/dev/null; then
  rm -f "$SSH_AUTH_SOCK"
fi
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent -a "$SSH_AUTH_SOCK" 2>/dev/null)
fi

## aliases
alias 0clock='echo "$(date +%s) $(TZ=UTC date)"; echo "Prague:    $(date)"; echo "Reykjavik: $(TZ=Atlantic/Reykjavik date)"; echo "Riyadh:    $(TZ=Asia/Riyadh date)"; echo "Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="fc-list | sed 's/^.\+: //;s/:.\+$//;s/,.*$//' | sort -u | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
alias 0mixon='pactl load-module module-loopback'
alias 0mixoff='pactl unload-module module-loopback'
alias 0proxy='ssh -CND 8815 188.166.105.125' # agaric.net
alias 0sshadd='ssh-add $HOME/.ssh/id_rsa'
alias 0topc="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time | sed '/^ 0.0 /d'"
alias 0topd="du -kx | ag -v '\./.+/' | sort -rn"
alias 0topm="ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz | awk '{if (\$1>5000) print;}'"
alias asdf='cat /sys/bus/usb/devices/*/product | grep -q "^The Planck Keyboard$" || setxkbmap -option ctrl:swapcaps; xmodmap $HOME/cfg/unstowed/hsnt/hsnt.xmodmap; xset r rate 300 30'
alias hsnt='cat /sys/bus/usb/devices/*/product | grep -q "^The Planck Keyboard$" && setxkbmap us || setxkbmap -option ctrl:swapcaps us; xset r rate 300 30'
alias cp='cp -iv'
alias g='git'
alias guile='rlwrap -ci guile'
alias ls='ls --color=auto --time-style=long-iso'
alias l='ls -AF'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
alias mv='mv -iv'
alias rm='rm -i'
alias pstree='pstree -hnp'
alias sudo='sudo '
alias tclsh='rlwrap -ci tclsh'
alias v='vim'
alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'

source /usr/share/bash-completion/completions/git
__git_complete g __git_main

## more functions
c()
{ cd "$@" && \
  { local lim=256 count=$(ls --color=n | wc -l);
    [[ $count -gt $lim ]] \
      && echo "skipping ls ($count entries > $lim)" \
      || l; }; }

0ftp()
{ local phone='192.168.2.3'
  [[ -z "$1" ]] && echo 'provide ftp password' \
    || sudo lftp -u b,$1 -p 21000 ftp://$phone; }

0qmk-flash()
{ [[ -n "$1" ]] \
  && { sudo dfu-programmer atmega32u4 erase \
  && sudo dfu-programmer atmega32u4 flash "$1" \
  && sudo dfu-programmer atmega32u4 reset; } \
  || echo 'no file given'; }

## set title
trap 'echo -ne "\033]0;($(echo $PWD | sed s,$HOME,~,)) $BASH_COMMAND\007"' DEBUG
