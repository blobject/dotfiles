[[ $- != *i* ]] && return

## settings
bind '"\en": menu-complete'
bind '"\ep": menu-complete-backward'
stty -ixon

## custom functions and variables
__0_pwd=$PWD

__0_git()
{ [[ -d .git ]] && git branch --no-color 2>/dev/null | sed '/^[^*]/d;s,^\* *\(.*\)$,\1 ,'; }

__0_hg()
{ if [[ -d .hg ]]; then
    a=$(hg stat 2>/dev/null | sed 's,^\(.\).\+$,\1,' | sort -u | sed 'N;s,\n,,')
    hg branch 2>/dev/null | sed 's/$/'"$a"' /'
  fi; }

__0_prompt()
{ local e=${PIPESTATUS[-1]}
  [[ $e = 0 ]] \
    && e='\[\033[0;32m\]'"$e " \
    || e='\[\033[0;35m\]'"$e "
  local t='\[\033[0;37m\]\t '
  local g='\[\033[0;33m\]'$(__0_git)
  local h='\[\033[0;33m\]'$(__0_hg)
  local p='\[\033[0;31m\]\w'
  PS1=$e$t$g$h$p'\[\033[0m\] '
  __0_pwd=$PWD; }

__0_title()
{ local c=$(history 1 | sed 's/^ *[0-9]\+ *//')
  [[ -z $__0_pwd ]] && c=alacritty
  echo -ne "\033]0;($(echo ${__0_pwd:-$PWD} | sed s,$HOME,~,)) $c\007"; }

0ftp()
{ local phone='192.168.2.3'
  [[ -z "$1" ]] && echo 'provide ftp password' \
    || sudo lftp -u b,$1 -p 21000 ftp://$phone; }

0qmk-flash()
{ #make planck/rev4:blobject:flash \
  sudo make planck/rev4:blobject \
  && sudo dfu-programmer atmega32u4 erase \
  && sudo dfu-programmer atmega32u4 flash planck_rev4_agaric.hex \
  && sudo dfu-programmer atmega32u4 reset; }

c()
{ cd "$@" && \
  { local lim=256 count=$(ls --color=n | wc -l);
    [[ $count -gt $lim ]] \
      && echo "skipping ls ($count entries > $lim)" \
      || ls -AF --color=auto --time-style=long-iso; }; }

## opt functions
# taken from broot setup
function br {
  f=$(mktemp)
  (
	set +e
	broot --outcmd "$f" "$@"
	code=$?
	if [ "$code" != 0 ]; then
	    rm -f "$f"
	    exit "$code"
	fi
  )
  code=$?
  if [ "$code" != 0 ]; then
    return "$code"
  fi
  d=$(<"$f")
  rm -f "$f"
  eval "$d"
}

## variables
HISTCONTROL=ignoreboth
HISTFILESIZE=65536
HISTSIZE=65536
PROMPT_COMMAND=__0_prompt
export LESS=-iRS
export SSH_AUTH_SOCK=$HOME/.ssh/agent
eval $(dircolors --sh $HOME/opt/cemant/dircolors)

## services
if ! pgrep -u $USER ssh-agent >/dev/null; then
  rm -f "$SSH_AUTH_SOCK"
fi
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  eval $(ssh-agent -a "$SSH_AUTH_SOCK" 2>/dev/null)
fi

## aliases
alias 0cam='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'
alias 0clock='echo "$(date +%s) $(TZ=UTC date)"; echo "Prague:    $(date)"; echo "Reykjavik: $(TZ=Atlantic/Reykjavik date)"; echo "Riyadh:    $(TZ=Asia/Riyadh date)"; echo "Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="pango-list | grep '^[^ ]' | sort | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
#alias 0mixon='pactl load-module module-loopback'
#alias 0mixoff='pactl unload-module module-loopback'
alias 0proxy='ssh -CND 8815 188.166.105.125' # aga
alias 0sshadd='ssh-add $HOME/.ssh/id_rsa'
alias 0stipe='ssh -t aga "cd www/stipe/db && bash"'
alias 0topc='ps -Ao pcpu,pid,cmd | sort -grk1 | head -17 | column -t -N %,pid,cmd | cut -c-$(tput cols)'
alias 0topm="ps -Ao pmem,rss,vsize,pid,args | awk '{if (\$2 > 10240) \$2=\$2/1024\"M\"; if (\$3 > 10240) \$3=\$3/1024\"M\";}{print;}' | sort -grk1 | head -25 | column -t -N %,rss,vsz,pid,cmd |"' cut -c-$(tput cols)'
alias asdf='0k lay hsnt'
alias asdfb='0k lay hsnt; 0k lay bow'
alias hsnt='0k lay qwerty'
alias hsntb='0k lay qwerty; 0k lay bow'
alias hsnt='0k lay qwerty'
alias bc='bc -l'
alias cp='cp -iv'
alias fd='fd --hidden --no-ignore'
alias le='less'
alias ls='ls --color=auto --time-style=long-iso'
alias l='ls -AF'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
#alias man='man -m /usr/lib/plan9/man'
alias mv='mv -iv'
alias nuget="mono $HOME/opt/nuget.exe"
alias pstree='pstree -hnp'
alias rg='rg -L --hidden'
alias rm='rm -i'
alias sudo='sudo '
alias guile='rlwrap -ci guile'
alias tclsh='rlwrap -ci tclsh'
alias wish='rlwrap -ci wish'
alias d='df -h'
alias e='kak'
alias f='free -m'
alias g='git'
alias m='mpv'
alias p='ps x'
alias t='tmux'
alias u='du -hs'
alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'

## imports
source /usr/share/bash-completion/completions/git
__git_complete g __git_main

## set title
trap __0_title DEBUG
unset __0_pwd

