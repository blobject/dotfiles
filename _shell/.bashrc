[[ $- != *i* ]] && return

## settings
stty -ixon

## functions
0gitbr()
{ git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'; }

## variables
PS1="\[\033[46;30m\] $? \[\033[0;37m\] \t \[\033[0;33m\]\$(0gitbr)\[\033[0;31m\]\w\[\033[0m\] "
HISTCONTROL=ignoreboth
HISTFILE="$HOME/.bashlog"
HISTFILESIZE=8192
HISTSIZE=8192
PS1="\[\033]0;\u@\h:\w\007\]\[\033[0;37m\]\t \[\033[0;33m\]\$(0gitbr)\[\033[0;31m\]\w\[\033[0m\] "
export PATH="$HOME/bin:${PATH:+:}$PATH"
export SSH_AUTH_SOCK="$HOME/.ssh/agent"

## services
if ! pgrep -u $USER ssh-agent >/dev/null; then
  rm -f "$SSH_AUTH_SOCK"
fi
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent -a "$SSH_AUTH_SOCK" 2>/dev/null)
fi

## aliases
alias 0clock='echo "$(date +%s)"; echo "  UTC:       $(TZ=UTC date)"; echo "* Prague:    $(date)"; echo "  London:    $(TZ=Europe/London date)"; echo "  Los Angls: $(TZ=America/Los_Angeles date)"; echo "  New York:  $(TZ=America/New_York date)"; echo "  Riyadh:    $(TZ=Asia/Riyadh date)"; echo "  Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="fc-list | sed 's/^.\+: //;s/:.\+$//;s/,.*$//' | sort -u | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
alias 0proxy='ssh -CND 8815 188.166.105.125' # agaric.net
alias 0qmk-build='docker run -e keymap=agaric -e subproject=rev4 -e keyboard=planck --rm -v $HOME/src/qmk_firmware:/qmk:rw edasque/qmk_firmware'
alias 0sshadd='ssh-add $HOME/.ssh/id_rsa'
alias 0top-c="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time | sed '/^ 0.0 /d'"
alias 0top-d="du -kx | ag -v '\./.+/' | sort -rn"
alias 0top-m="ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz | awk '{if (\$1>5000) print;}'"
alias asdf='xmodmap $HOME/cfg/hsnt/hsnt.xmodmap'
alias hsnt='setxkbmap us'
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

