[[ $- != *i* ]] && return

## settings
bind '"\en": menu-complete'
bind '"\ep": menu-complete-backward'
stty -ixon

## custom functions and variables
__0_prompt_pwd=$PWD

__0_prompt_conda()
{ if [[ $CONDA_SHLVL -gt 1 ]]; then
    echo "c\[\033[0;36m\]$CONDA_DEFAULT_ENV "
  fi; }

__0_prompt_poetry()
{ if [[ -v VIRTUAL_ENV ]]; then
    local a=$(basename $VIRTUAL_ENV)
    echo "p\[\033[0;36m\]${a%-*-*} "
  fi; }

__0_prompt_git()
{ if git rev-parse --is-inside-work-tree &>/dev/null; then
    local a=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ x = x$a ]]; then
      echo 'g\[\033[0;33m\]*detached* '
      return
    fi
    echo $a | sed 's/$/ /;s/^/g\\[\\033[0;33m\\]/'
  fi; }

__0_prompt_hg()
{ #if hg id &>/dev/null; then
  if [[ -d .hg ]]; then
    local a=$(hg stat 2>/dev/null | sed 's,^\(.\).\+$,\1,' | sort -u | sed 'N;s,\n,,')
    hg branch 2>/dev/null | sed 's/$/'"$a"' /;s/^/h\\[\\033[0;33m\\]/'
  fi; }

__0_prompt()
{ local e=${PIPESTATUS[-1]}
  [[ $e = 0 ]] \
    && e='\[\033[0;32m\]'"$e " \
    || e='\[\033[0;35m\]'"$e "
  local t='\[\033[2;37m\]\t\[\033[0m\] '
  local c='\[\033[1;36m\]'$(__0_prompt_conda)
  local p='\[\033[1;36m\]'$(__0_prompt_poetry)
  local g='\[\033[1;33m\]'$(__0_prompt_git)
  local h='\[\033[1;33m\]'$(__0_prompt_hg)
  local d='\[\033[0;31m\]\w'
  PS1='\[\033[0;37m\]╭╴'$e$t$c$p$g$h$d'\n\[\033[0;37m\]╰╴\[\033[0m\]'
  __0_prompt_pwd=$PWD; }

__0_title()
{ local c=$(history 1 | sed 's/^ *[0-9]\+ *//')
  [[ -z $__0_prompt_pwd ]] && c=$TERMINAL
  echo -ne "\033]0;($(echo ${__0_prompt_pwd:-$PWD} | sed s,$HOME,~,)) $c\007"; }

0conda()
{ if [[ 'base' != "$1" && ! -d "$HOME/opt/miniconda3/envs/$1" ]]; then
    echo "bad conda env: $1"
    return
  fi
  eval "$(command $HOME/opt/miniconda3/condabin/conda 'shell.bash' 'hook')"
  conda activate $1; }

0ftp()
{ local net=$(ip a | rg -o 'inet.*global dynamic' | cut -d' ' -f2)
  net=${net%.*}
  local port='21000'
  [[ $# -ne 2 ]] && echo 'provide phone address & ftp password' \
    || sudo lftp -u "b,$2" -p $port "ftp://$net.$1"; }

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

## variables
HISTCONTROL=ignoreboth
HISTFILESIZE=131072
HISTSIZE=131072
PROMPT_COMMAND=__0_prompt
export LESS=-iRS
export SSH_AUTH_SOCK=$HOME/.ssh/agent
eval $(dircolors --sh $HOME/opt/cemant/dircolors/dircolors_blobject)

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
alias 0ear='bluetoothctl connect B0:F1:A3:63:0A:66'
alias 0fonts="pango-list | grep '^[^ ]' | sort | pr -2 -T"
alias 0ip='wget -qO - https://ipinfo.io/ip'
#alias 0mixon='pactl load-module module-loopback'
#alias 0mixoff='pactl unload-module module-loopback'
#alias 0proxy='ssh -CND 8815 as'
alias 0sec='encfs $HOME/ref/.secret $HOME/ref/secret'
alias 0secret='fusermount -u $HOME/ref/secret'
alias 0sshadd='ssh-add $HOME/.ssh/id_rsa'
alias 0topc='ps -Ao pcpu,pid,cmd | sort -grk1 | head -17 | column -t -N %,pid,cmd | cut -c-$(tput cols)'
alias 0topm="ps -Ao pmem,rss,vsize,pid,args | awk '{if (\$2 > 10240) \$2=\$2/1024\"M\"; if (\$3 > 10240) \$3=\$3/1024\"M\";}{print;}' | sort -grk1 | head -25 | column -t -N %,rss,vsz,pid,cmd |"' cut -c-$(tput cols)'
#alias 0usb='lsusb | sort -k7 | rg -v 1d6b: | rg -v 8087:0aaa | rg -v 13d3:56c6'
alias bc='bc -l'
alias cp='cp -iv'
alias dmesg='dmesg --color=always'
alias fd='fd --hidden --no-ignore'
alias le='less'
alias ls='ls --color=auto --time-style=long-iso'
alias lsn='fd . --exclude "\\.git/" --ignore --print0 --type file | xargs -0 stat --format "%Y :%y %n" | sort -nr | cut -d: -f2-'
alias l='ls -AF'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
#alias man='man -m /usr/lib/plan9/man'
alias mv='mv -iv'
alias pstree='pstree -hnp'
alias rg='rg -L --hidden -g!*.min.js'
alias rm='rm -i'
alias sudo='sudo '
alias guile='rlwrap -ci guile'
alias tclsh='rlwrap -ci tclsh'
alias wish='rlwrap -ci wish'
alias b='bluetoothctl'
alias d='df -h'
alias dk='docker'
alias e='kak'
alias f='free -m'
alias g='git'
alias m='mpv'
alias ma='mpv --audio=no'
alias p='ps aux'
alias t='tmux'
alias u='du -hs'
alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'
alias ,,,,,='c ../../../../..'
alias ,,,,,,='c ../../../../../..'
alias ,,,,,,,='c ../../../../../../..'
alias ,,,,,,,,='c ../../../../../../../..'

## imports
source /usr/share/bash-completion/completions/docker
source /usr/share/bash-completion/completions/git
source /usr/share/bash-completion/completions/mpv
__git_complete dk _docker
__git_complete g __git_main
__git_complete m _mpv
__git_complete ma _mpv

## set title
trap __0_title DEBUG
unset __0_prompt_pwd

## work
__0_work()
{ local e=$(cat /home/work/src/_env/$1)
  case "$1" in
    0)
      local n="node /home/work/src/$e/node_modules"
      alias black="black --diff"
      alias eslint="$n/eslint/bin/eslint.js"
      #alias prettier="$n/prettier/bin-prettier.js --check"
      alias sass="$n/sass/sass.js"
      alias _py="cd $HOME/opt/miniconda3/envs/$e/lib/$(basename $(find $HOME/opt/miniconda3/envs/$e/lib -maxdepth 1 -type d -name 'python*' | head -1))/site-packages"
      cd /home/work/src/$e
      source ../_env/env$e.sh
      0conda $e
      ;;
    1)
      alias _py="cd $HOME/opt/miniconda3/envs/$e/lib/$(basename $(find $HOME/opt/miniconda3/envs/$e/lib -maxdepth 1 -type d -name 'python*' | head -1))/site-packages"
      cd /home/work/src/$e
      source ../_env/env$e.sh
      0conda $e
      ;;
    2)
      local n="node /home/work/src/$e/node_modules"
      alias eslint="$n/eslint/bin/eslint.js"
      alias prettier="$n/prettier/bin-prettier.js --check"
      alias vitest="$n/vitest/vitest.mjs"
      cd /home/work/src/$e
      ;;
  esac; }

alias _='cd /home/work/src'
alias work='__0_work 0'
alias work_='__0_work 1'
alias work__='__0_work 2'
