export SHELL
[[ $- != *i* ]] && { [[ -n "$SSH_CLIENT" ]] && source /etc/profile; return; }

#PS1='\e[31m$?\e[0m\e[37m\t\e[0m\e[47;30m\w\e[0m '
PS1='$? \t \w '
[[ -n "$GUIX_ENVIRONMENT" ]] && PS1="[env] $PS1"

HISTCONTROL=ignoreboth
HISTFILE="$HOME/.bashlog"
HISTFILESIZE=8192
HISTSIZE=8192

B_PROF="$HOME/.guix-profile"
B_TMP="/dev/shm/_${USER}_tmp"

export PATH="$HOME/bin:$HOME/.opam/system/bin:$B_PROF/sbin${PATH:+:}$PATH"
export CMAKE_PREFIX_PATH="$B_PROF${CMAKE_PREFIX_PATH:+:}$CMAKE_PREFIX_PATH"
#export CURLOPT_CAPATH="$B_PROF/etc/ssl/certs${CURLOPT_CAPATH:+:}$CURLOPT_CAPATH"
export GIT_EXEC_PATH="$B_PROF/libexec/git-core"
export GIT_SSL_CAINFO="$B_PROF/etc/ssl/certs/ca-certificates.crt"
export PKG_CONFIG_PATH="$B_PROF/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"
export LESS=-imRS
export LESSHISTFILE=-
export XDG_DATA_DIRS="$B_PROF/share/glib-2.0/schemas${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"
export XDG_RUNTIME_DIR="/tmp/runtime-$USER"

[[ -d $XDG_RUNTIME_DIR ]] || mkdir -p $XDG_RUNTIME_DIR
! pgrep -u "$USER" ssh-agent >/dev/null \
  && ssh-agent | grep -v echo >"$HOME/.ssh/agent"
[[ -z "$SSH_AGENT_PID" ]] && eval $(cat "$HOME/.ssh/agent")
! pgrep -u "$USER" gpg-agent >/dev/null \
  && eval $(gpg-agent --daemon)
eval $(dircolors --sh "$HOME/cfg/dircolors")
stty -ixon # stop freezing in vim when ctrl-s
trap 'echo -ne "\e]2;$BASH_COMMAND\a"' DEBUG # dynamic title

#. $HOME/.opam/opam-init/init.sh >/dev/null 2>/dev/null

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias ls='ls --color=auto --time-style=long-iso'
alias l='ls -A'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
#alias am=alsamixer
alias bc='rlwrap -ci bc'
alias diff='diff --color'
alias dmesg='dmesg --color=always'
alias e='emacsclient -nc'
alias g=git
alias guile='rlwrap -ci guile'
alias lein='rlwrap -ci lein'
alias ocaml='rlwrap -ci ocaml'
alias pstree='pstree -hnp'
#alias sbcl='rlwrap -ci sbcl'
alias tclsh='rlwrap -ci tclsh'
alias sudo='sudo '
alias v=vim
alias vlc=0vlc
alias 0clock='echo "$(date +%s)"; echo "  UTC:       $(TZ=UTC date)"; echo "* Prague:    $(date)"; echo "  London:    $(TZ=Europe/London date)"; echo "  Los Angls: $(TZ=America/Los_Angeles date)"; echo "  New York:  $(TZ=America/New_York date)"; echo "  Riyadh:    $(TZ=Asia/Riyadh date)"; echo "  Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="fc-list | sed 's/^.\+: //;s/:.\+$//;s/,.*$//' | sort -u | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
alias 0proxy='ssh -CND 8815 agaric.net'
alias 0top-c="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time | sed '/^ 0.0 /d'"
alias 0top-d="du -kx | ag -v '\./.+/' | sort -rn"
alias 0top-m="ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz | awk '{if (\$1>5000) print;}'"
alias 0qmk-build='docker run -e keymap=agaric -e subproject=rev4 -e keyboard=planck --rm -v $HOME/src/qmk_firmware:/qmk:rw edasque/qmk_firmware'

c() { cd "$@" && \
  { local lim=256 count=$(ls --color=n | wc -l);
    [[ $count -gt $lim ]] \
      && echo "skipping ls ($count entries > $lim)" \
      || l; }; }
alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'
alias ,,,,,='c ../../../../..'

0qmk-flash()
{ [ -n "$1" ] \
  && { sudo dfu-programmer atmega32u4 erase \
  && sudo dfu-programmer atmega32u4 flash "$1" \
  && sudo dfu-programmer atmega32u4 reset; } \
  || echo 'no file given'; }
