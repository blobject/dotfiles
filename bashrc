export SHELL
[[ $- != *i* ]] && { [[ -n "$SSH_CLIENT" ]] && source /etc/profile; return; }

[[ -n "$GUIX_ENVIRONMENT" ]] && PS1='[env] \w ' || PS1='\w '

HISTCONTROL=ignoreboth
HISTFILE="$HOME/.bashlog"
HISTFILESIZE=8192
HISTSIZE=8192

export PATH="$HOME/bin:$HOME/.guix-profile/sbin${PATH:+:}$PATH"
export CMAKE_PREFIX_PATH="$HOME/.guix-profile${CMAKE_PREFIX_PATH:+:}$CMAKE_PREFIX_PATH"
export CPATH="$HOME/.guix-profile/include${CPATH:+:}$CPATH"
export GHC_PACKAGE_PATH="$HOME/.guix-profile/lib/ghc-8.0.2/package.conf.d${GHC_PACKAGE_PATH:+:}$GHC_PACKAGE_PATH"
export GIT_EXEC_PATH="$HOME/.guix-profile/libexec/git-core"
export GIT_SSL_CAINFO="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
export LIBRARY_PATH="$HOME/.guix-profile/lib:$HOME/.guix-profile/lib64${LIBRARY_PATH:+:}$LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/.guix-profile/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"
export PYTHONPATH="$HOME/.guix-profile/lib/python3.6/site-packages${PYTHONPATH:+:}$PYTHONPATH"
export LESS=-imRS
export LESSHISTFILE=-
export XDG_DATA_DIRS="$HOME/.guix-profile/share/glib-2.0/schemas${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"
export XDG_RUNTIME_DIR="/tmp/runtime-$USER"

[[ -d $XDG_RUNTIME_DIR ]] || mkdir -p $XDG_RUNTIME_DIR
B_TMP="/tmp/_${USER}_tmp"
! pgrep -u "$USER" ssh-agent >/dev/null \
  && mkdir -p "$B_TMP" \
  && ssh-agent | grep -v echo >"$B_TMP/ssh-agent"
[[ -z "$SSH_AGENT_PID" ]] && eval "$(<$B_TMP/ssh-agent)"
eval $(dircolors --sh "$HOME/.config/dircolors")
stty -ixon # stop freezing in vim when ctrl-s
trap 'echo -ne "\e]2;$BASH_COMMAND\a"' DEBUG # dynamic title

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias ls='ls --color=auto --time-style=long-iso'
alias l='ls -A'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
alias am=alsamixer
alias bc='rlwrap bc'
alias diff='diff --color'
alias dmesg='dmesg --color=always'
alias e='emacsclient -nc'
alias g=git
alias guile='rlwrap guile'
alias lein='rlwrap lein'
alias pstree='pstree -hnp'
alias rg='rg --colors match:fg:black --colors match:style:nobold --colors path:style:bold --colors line:fg:yellow'
alias sbcl='rlwrap sbcl'
alias tclsh='rlwrap tclsh'
alias sudo='sudo '
alias v=vim
alias vlc=0vlc
alias 0clock='echo "$(date +%s)"; echo "  UTC:       $(TZ=UTC date)"; echo "* Prague:    $(date)"; echo "  London:    $(TZ=Europe/London date)"; echo "  Los Angls: $(TZ=America/Los_Angeles date)"; echo "  New York:  $(TZ=America/New_York date)"; echo "  Riyadh:    $(TZ=Asia/Riyadh date)"; echo "  Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="fc-list | sed 's/^.\+: //;s/:.\+$//;s/,.*$//' | sort -u | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
alias 0top-c="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time | sed '/^ 0.0 /d'"
alias 0top-d="du -kx | rg -v '\./.+/' | sort -rn"
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
