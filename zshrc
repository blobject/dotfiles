# .zshrc

[ "$TERM" = screen ] && TERM=screen-256color
PATH="$HOME/opt/bin:/usr/local/bin:/usr/local/sbin:$PATH:/sbin:/usr/sbin"
EDITOR=/usr/bin/vim
VISUAL=/usr/bin/vim
PAGER=/usr/bin/less  # for i3
TERMINAL=/usr/bin/st  # for i3
LESS=-imRS  # icase search,verbose,rawcolor,chop
LESSHISTFILE=-
B_DAT=/data     # used in .xinitrc,0save
B_IPC=/tmp/b_ipc    # used in .xinitrc,0core,0hot
B_NOW='%d%b%y-%H%M%S' # used in 0hot,0save
export TERM EDITOR VISUAL PAGER TERMINAL LESS LESSHISTFILE B_DAT B_IPC B_NOW

HISTFILE=$HOME/.zshlog
HISTSIZE=2048
SAVEHIST=1024
autoload -Uz compinit; compinit
autoload -U select-word-style; select-word-style bash
zstyle ':completion:*' cache-path $HOME/.cache/zsh
zstyle ':completion::complete:*' use-cache 1
bindkey -e  # emacs style
bindkey '^[[Z'  reverse-menu-complete  # s-tab
bindkey '^[[1~' beginning-of-line      # home
bindkey '^[[4~' end-of-line            # end
bindkey '^[[3~' delete-char            # del
bindkey '^[[2~' overwrite-mode         # ins
setopt extendedglob histignoredups histignorespace listpacked notify rmstarwait
unsetopt beep histbeep listbeep
stty -ixon
if [ "$TERM" != linux ]; then
  function zle-line-init () { echoti smkx }
  function zle-line-finish () { echoti rmkx }
  zle -N zle-line-init  # for del/ins to work on st
  zle -N zle-line-finish; fi

precmd() {
  PS1=%{$'\e[1m'%}"$(echo ${PWD/#$HOME/\~}|sed 's!\([^/]\{3\}\)[^/]\{2,\}/!\1+/!g')"%{$'\e[0m'%}' '
  [ $TERM = linux ] || printf "\a"; }
[ $TERM = linux ] || preexec() {
  #PROMPT_COMMAND="printf '\033k$(hostname)\033\\';"${PROMPT_COMMAND}
  local quo="$(echo ${PWD/#$HOME/\~}|sed 's!\([^/ :]\{2\}\)[^/ :]*/!\1/!g')"
  local que="$(echo $2|sed 's/ --color=auto//g')"
  print -Pn "\e]0;[$quo] $que\a"; }

alias   cp='cp -iv'
alias   mv='mv -iv'
alias   rm='rm -i'
alias grep='grep --color=auto'
alias   ls='ls --color=auto'
alias    l='ls -A'
alias   ll='ls -lh'
alias  lla='ll -a'
alias  lls='ll -S'  # size
alias  llt='ll -t'  # time
alias sudo='sudo '
alias    v='vim'
alias pstree='pstree -h'
alias 0fonts="fc-list|sed 's/^.\+: //;s/:.\+$//;s/,.*$//'|sort -u|pr -2 -T"
alias   0psc="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time|sed '/^ 0.0 /d'"
alias   0psm='ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz|awk "{if(\$1>5000)print;}"'
c() { cd "$@" && \
  { local lim=128 count=$(ls --color=n|wc -l);
    [ $count -gt $lim ] \
    && echo "skipping ls ($count entries > $lim)" \
    || l; }; }
alias     ..='c ..'
alias    ...='c ../..'
alias   ....='c ../../..'
alias  .....='c ../../../..'

#alias   0fus='sshfs -o idmap=user s:/ /mnt/s'
#alias   0fub='sshfs -o idmap=user s:/home/b /mnt/s'
#alias   0fun='fusermount -u /mnt/s'
#alias  0tune='vlc http://192.168.1.10:8000 -I ncurses'
#alias     bc='bc -l /usr/local/lib/bc/{custom,typography}.bc'
#alias    mpc='mpc -h 192.168.1.10 -p 6600'
#alias mpcloop='while true; do clear;mpc;sleep 10;done'
#
eval "$(dircolors $HOME/.config/dircolors)"
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose 'yes'
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:manuals' separate-sections true
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'no %d'
compdef _command bgin=command
compdef _cd c=cd

0ftp()
{ local host=nexus5  # see: /etc/hosts
  [ -z "$1" ] || host="$1"
  lftp -p 20080 -u b,fly "ftp://$host"; }

[ $(tty) = /dev/tty4 ] && [ -z $DISPLAY ] && \
{ mv -f $HOME/.xlog $HOME/.xlog.old >/dev/null 2>/dev/null
  xinit >/dev/null 2>$HOME/.xlog; }

