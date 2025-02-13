! test -t 0 && return

## settings
bind '"\en": menu-complete'
bind '"\ep": menu-complete-backward'
stty -ixon

## custom functions and variables
__0_prompt_pwd=$PWD

__0_prompt_conda()
{ if test "0$CONDA_SHLVL" -gt 1; then
    echo "c\[\033[0;36m\]$CONDA_DEFAULT_ENV "
  fi; }

__0_prompt_poetry()
{ if test -v VIRTUAL_ENV; then
    local a
    a=$(basename "$VIRTUAL_ENV")
    echo "p\[\033[0;36m\]${a%-*-*} "
  fi; }

__0_prompt_git()
{ if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    local a
    a=$(git symbolic-ref --short HEAD 2> /dev/null)
    if test '' = "$a"; then
      a=$(git describe --tags 2> /dev/null)
      if test '' = "$a"; then
        echo 'g\[\033[0;33m\]*detached* '
        return
      fi
      echo "gt\[\033[0;33m\]${a} "
      return
    fi
    echo "$a" | sed 's,$, ,;s,^,g\\[\\033[0;33m\\],'
  fi; }

__0_prompt_hg()
{ #if hg id > /dev/null 2>&1; then
  if test -d .hg; then
    local a
    a=$(hg stat 2> /dev/null | sed 's,^\(.\).\+$,\1,' | sort -u | sed 'N;s,\n,,')
    hg branch 2> /dev/null | sed 's,$,'"$a"' ,;s,^,h\\[\\033[0;33m\\],'
  fi; }

__0_prompt()
{ local e
  e=${PIPESTATUS[-1]}
  test "$e" = 0 \
    && e='\[\033[0;32m\]'"$e " \
    || e='\[\033[0;35m\]'"$e "
  local t c p g h d
  t='\[\033[2;37m\]\t\[\033[0m\] '
  c='\[\033[1;36m\]'$(__0_prompt_conda)
  p='\[\033[1;36m\]'$(__0_prompt_poetry)
  g='\[\033[1;33m\]'$(__0_prompt_git)
  h='\[\033[1;33m\]'$(__0_prompt_hg)
  d='\[\033[0;31m\]\w'
  PS1='\[\033[0;37m\]╭╴'$e$t$c$p$g$h$d'\n\[\033[0;37m\]╰╴\[\033[0m\]'
  __0_prompt_pwd=$PWD; }

__0_title()
{ local c
  c=$(history 1 | sed 's,^ *[0-9]\+ *,,')
  test -z "$__0_prompt_pwd" && c=$TERMINAL
  echo -ne "\033]0;($(echo ${__0_prompt_pwd:-$PWD} | sed 's,^'$HOME'$,~,;s,^'$HOME'/,~/,;s,^/home/work$,+,;s,^/home/work/,+/,')) $c\007"; }

0conda()
{ if test 'base' != "$1" && ! test -d "$HOME/opt/miniconda3/envs/$1"; then
    echo "bad conda env: $1"
    return
  fi
  eval "$(command $HOME/opt/miniconda3/condabin/conda 'shell.bash' 'hook')"
  conda activate "$1"; }

0ftp()
{ local net port
  net=$(ip a | rg -o 'inet.*global dynamic' | cut -d' ' -f2)
  net=${net%.*}
  port='21000'
  test "$#" -ne 2 && echo 'provide phone address & ftp password' \
    || sudo lftp -u "b,$2" -p "$port" "ftp://$net.$1"; }

0qmk-flash()
{ #make planck/rev4:blobject:flash \
  sudo make planck/rev4:blobject \
  && sudo dfu-programmer atmega32u4 erase \
  && sudo dfu-programmer atmega32u4 flash planck_rev4_agaric.hex \
  && sudo dfu-programmer atmega32u4 reset; }

c()
{ cd "$@" && \
  { local lim count
    lim=256
    count=$(ls --color=n | wc -l);
    test "$count" -gt "$lim" \
      && echo "skipping ls ($count entries > "$lim")" \
      || ls -AF --color=auto --time-style=long-iso; }; }

## variables
HISTCONTROL=ignoreboth
HISTFILESIZE=131072
HISTSIZE=131072
PROMPT_COMMAND=__0_prompt
LESS=-iRS
SSH_AUTH_SOCK=$HOME/.ssh/agent
export LESS SSH_AUTH_SOCK
eval $(dircolors --sh "$HOME/opt/cemant/dircolors/dircolors_blobject")

## services
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  rm -f "$SSH_AUTH_SOCK"
fi
if ! test -S "$SSH_AUTH_SOCK"; then
  eval $(ssh-agent -a "$SSH_AUTH_SOCK" 2> /dev/null)
fi

## aliases
alias 0cam='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'
alias 0clock='echo "$(date +%s) $(TZ=UTC date)"; echo "Prague:    $(TZ=Europe/Prague date)"; echo "Reykjavik: $(TZ=Atlantic/Reykjavik date)"; echo "Riyadh:    $(TZ=Asia/Riyadh date)"; echo "Seoul:     $(TZ=Asia/Seoul date)"; echo "Singapore: $(date)"'
alias 0ear='bluetoothctl connect B0:F1:A3:63:0A:66'
alias 0fonts="pango-list | grep '^[^ ]' | sort | pr -2 -T"
alias 0gpu_unplug="sudo modprobe -r amdgpu && sudo sh -c \"echo 1 > /sys/bus/pci/devices/0000:$(lspci | grep ' VGA ' | grep Radeon | head -1 | cut -d' ' -f1)/remove\""
alias 0ip='curl https://ipinfo.io/ip; echo'
#alias 0mixon='pactl load-module module-loopback'
#alias 0mixoff='pactl unload-module module-loopback'
alias 0mount='mount -o uid=$UID,gid=$GROUPS'
alias 0proxy='ssh -CND 8815 as'
alias 0pixel='grim -g "$(slurp -p)" -t ppm - | convert - -format "%[pixel:p{0,0}]" txt:-'
alias 0py='python -m env $HOME/opt/python/env'
alias 0sec='gocryptfs $HOME/ref/.secret $HOME/ref/secret'
alias 0secret='fusermount -u $HOME/ref/secret'
alias 0sshadd='ssh-add $HOME/.ssh/id_rsa'
alias 0su='sudo su -s $(which bash)'
alias 0topc='ps -Ao pcpu,pid,cmd | sort -grk1 | head -17 | column -t -N %,pid,cmd | cut -c-$(tput cols)'
alias 0topm="ps -Ao pmem,rss,vsize,pid,args | awk '{if (\$2 > 10240) \$2=\$2/1024\"M\"; if (\$3 > 10240) \$3=\$3/1024\"M\";}{print;}' | sort -grk1 | head -25 | column -t -N %,rss,vsz,pid,cmd |"' cut -c-$(tput cols)'
#alias 0usb='lsusb | sort -k7 | rg -v 1d6b: | rg -v 8087:0aaa | rg -v 13d3:56c6'
alias bc='bc -l'
alias cal='cal -m'
alias cp='cp -iv'
alias dmesg='dmesg --color=always'
alias fd='fd --hidden --no-ignore'
alias imv='imv -b checks'
alias le='less'
alias ls='ls --color=auto --time-style=long-iso'
alias lstop='fd . --exclude "\\.git/" --ignore --print0 --type file | xargs -0 stat --format "%Y :%y %n" | sort -nr | cut -d: -f2-'
alias l='ls -AF'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
#alias man='man -m /usr/lib/plan9/man'
alias mv='mv -iv'
alias pstree='pstree -hnp'
alias rg='rg -L --hidden -g!*.min.js -g!*.js.map'
alias rm='rm -i'
alias sudo='sudo '
alias guile='rlwrap -ci guile'
alias tclsh='rlwrap -ci tclsh'
alias wish='rlwrap -ci wish'
alias b='bluetoothctl'
alias d='df -h'
alias e='kak'
alias f='free -h'
alias g='git'
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
complete -C $HOME/opt/aws/dist/aws_completer aws
. /usr/share/bash-completion/completions/git
__git_complete g __git_main
source $HOME/cfg/opt/_shell/bash_completion_poetry.sh

## set title
trap __0_title DEBUG
unset __0_prompt_pwd

## work
__0_work()
{ local _w _e _d _np _ppd _pp
  _w=/home/work
  _e="$(cat $_w/env/$1)"
  _d="$_w/src/$_e"
  _np="node $_d/node_modules"
  _ppd="$HOME/opt/miniconda3/envs/$_e/lib"
  _pp=""
  test -d $_ppd && _pp="$(fd --max-depth 1 --max-results 1 --type d python $_ppd)site-packages"
  case "$1" in
    _)
      export NODE_OPTIONS=--max-old-space-size=25600
      alias black="black --diff"
      alias eslint="$_np/eslint/bin/eslint.js -c $_d/.eslintrc.cjs --ext .js,.jsx,.ts,.tsx"
      alias prettier="$_np/prettier/bin-prettier.js"
      alias sass="$_np/sass/sass.js"
      alias tsc="$_np/typescript/bin/tsc --noemit"
      alias _node="cd $_d/node_modules"
      alias _python="test -z $_pp && echo \"no dir: $_ppd\" || cd $_pp"
      0conda "$_e"
      cd "$_d"
      . "../../env/env_$_e.sh"
      export PYTHONPATH="$_d${PYTHONPATH:+:$PYTHONPATH}"
      ;;
    __|[1-4])
      alias _python="test -z $_pp && echo \"no dir: $_ppd\" || cd $_pp"
      0conda "$_e"
      cd "$_d"
      . "../../env/env_$_e.sh"
      export PYTHONPATH="$_d${PYTHONPATH:+:$PYTHONPATH}"
      ;;
    ___)
      alias eslint="$_np/eslint/bin/eslint.js -c $_d/eslint.config.mjs"
      alias graphql-codegen="$_np/.bin/graphql-codegen"
      alias prettier="$_np/prettier/bin-prettier.js"
      alias tsc="$_np/typescript/bin/tsc --noemit"
      alias _node="cd $_d/node_modules"
      cd "$_d"
      . "../../env/env_$_e.sh"
      ;;
    ____)
      cd "$_d"
      . "../../env/env_$_e.sh"
      ;;
  esac; }

alias _='cd /home/work/src'
alias work='__0_work _'
alias work_='__0_work __'
alias work__='__0_work ___'
alias work___='__0_work ____'
alias work1='__0_work 1'
alias work2='__0_work 2'
alias work3='__0_work 3'
alias work4='__0_work 4'
# eof
