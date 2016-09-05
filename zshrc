# .zshrc

[ "$TERM" = screen ] && TERM=screen-256color
PATH="$PATH:/sbin:/usr/sbin:$HOME/opt/bin:/usr/local/bin:/usr/local/sbin:$HOME/.gem/ruby/2.1.0/bin"
EDITOR='emacsclient -nc'
VISUAL='emacsclient -nc'
PAGER=less  # for i3
TERMINAL=st  # for i3
LESS=-imRS  # icase search,verbose,rawcolor,chop
LESSHISTFILE=-
B_DAT=/data  # used in .xinitrc,0save
B_IPC=/tmp/b_ipc  # used in .xinitrc,0core,0hot
B_NOW='%d%b%y-%H%M%S'  # used in 0hot,0save
export TERM EDITOR VISUAL PAGER TERMINAL LESS LESSHISTFILE B_DAT B_IPC B_NOW

HISTFILE=$HOME/.zshlog
HISTSIZE=4096
SAVEHIST=4096
autoload -Uz compinit; compinit
autoload -Uz vcs_info
autoload -U select-word-style; select-word-style bash
zstyle ':completion:*' cache-path $HOME/.cache/zsh
zstyle ':completion::complete:*' use-cache 1
bindkey -e
bindkey '^[[Z'  reverse-menu-complete  # s-tab
bindkey '^[[1~' beginning-of-line      # home
bindkey '^[[4~' end-of-line            # end
bindkey '^[[3~' delete-char            # del
bindkey '^[[2~' overwrite-mode         # ins
setopt extendedglob histignoredups histignorespace listpacked notify prompt_subst rmstarwait
unsetopt beep histbeep listbeep
stty -ixon
if [ "$TERM" != linux ] && [ "$TERM" != eterm-color ]; then
  function zle-line-init () { echoti smkx }
  function zle-line-finish () { echoti rmkx }
  zle -N zle-line-init  # for del/ins to work on st
  zle -N zle-line-finish; fi

precmd() {
  PS1=%{$'\e[1;36m'%}"$(echo ${PWD/#$HOME/\~}|sed 's!\([^/]\{3\}\)[^/]\{2,\}/!\1+/!g')"%{$'\e[0m'%}' '
  [ "$TERM" = linux ] || printf "\a"; }
[ "$TERM" = linux ] || [ "$TERM" = eterm-color ] || preexec() {
  #PROMPT_COMMAND="printf '\033k$(hostname)\033\\';"${PROMPT_COMMAND}
  local quo="$(echo ${PWD/#$HOME/\~}|sed 's!\([^/ :]\{2\}\)[^/ :]*/!\1/!g')"
  local que="$(echo $2|sed 's/ --color=auto//g')"
  print -Pn "\e]0;[$quo] $que\a"; }
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
RPROMPT=%{$'\e[1;36m'%}\$vcs_info_msg_0_%{$'\e[0m'%}

alias   ag="ag --color-line-number '33' --color-match '37' --color-path '1;35' "
alias   cp='cp -iv'
alias   mv='mv -iv'
alias   rm='rm -i'
alias   ls='ls --color=auto'
alias    l='ls -A'
alias   ll='ls -lh'
alias  lla='ll -a'
alias  lls='ll -S'  # size
alias  llt='ll -t'  # time
alias sudo='sudo '
alias    e='emacsclient -nc '
alias    g='git '
alias    v='vim '
alias pstree='pstree -h '
alias 0fonts="fc-list|sed 's/^.\+: //;s/:.\+$//;s/,.*$//'|sort -u|pr -2 -T"
alias   0psc="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time|sed '/^ 0.0 /d'"
alias   0psm='ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz|awk "{if(\$1>5000)print;}"'
alias 0update='sudo emerge --sync && sudo q -r && sudo emerge -uDNa @world'
alias 1lint="$HOME/src/kona/node_modules/eslint/bin/eslint.js $HOME/src/kona/client/"
c() { cd "$@" && \
  { local lim=128 count=$(ls --color=n|wc -l);
    [ $count -gt $lim ] \
    && echo "skipping ls ($count entries > $lim)" \
    || l; }; }
alias     ..='c ..'
alias    ...='c ../..'
alias   ....='c ../../..'
alias  .....='c ../../../..'

eval "$(dircolors $HOME/.config/dircolors)"
source /usr/bin/aws_zsh_completer.sh

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose 'yes'
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:manuals' separate-sections true
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'no %d'
zstyle ':vcs_info:git:*' formats '%b'
compdef _command bgin=command
compdef _cd c=cd

[ $(tty) = /dev/tty4 ] && [ -z $DISPLAY ] && \
{ mv -f $HOME/.xlog $HOME/.xlog.old >/dev/null 2>/dev/null
  xinit >/dev/null 2>$HOME/.xlog; }
