# .zshrc

[ "$TERM" = screen ] && TERM=screen-256color
PATH="$HOME/.gem/ruby/2.1.0/bin${PATH:+:}$PATH"
PATH="/sbin:/usr/sbin:$HOME/opt/bin:/usr/local/sbin:/usr/local/games${PATH:+:}$PATH"
PATH="$HOME/.guix-profile/bin:$HOME/.guix-profile/sbin${PATH:+:}$PATH"
export PATH
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
export INFOPATH="$HOME/.guix-profile/share/info:${INFOPATH:+:}$INFOPATH"
export MANPATH="$HOME/.guix-profile/share/man:$HOME/opt/share/man:/usr/local/man${MANPATH:+:}$MANPATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
export EDITOR='emacsclient -nc'
export VISUAL='emacsclient -nc'
export PAGER=less
export TERMINAL=st
export LESS=-imRS  # icase search,verbose,rawcolor,chop
export LESSHISTFILE=-

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
  PS1=%{$'\e[0;37m'%}"$(echo ${PWD/#$HOME/\~} | sed 's!\([^/]\{3\}\)[^/]\{2,\}/!\1+/!g')"%{$'\e[0m'%}' '
  [ "$TERM" = linux ] || printf "\a"; }
[ "$TERM" = linux ] || [ "$TERM" = eterm-color ] || preexec() {
  #PROMPT_COMMAND="printf '\033k$(hostname)\033\\';"${PROMPT_COMMAND}
  local quo="$(echo ${PWD/#$HOME/\~} | sed 's!\([^/ :]\{2\}\)[^/ :]*/!\1/!g')"
  local que="$(echo $2 | sed 's/ --color=auto//g')"
  print -Pn "\e]0;[$quo] $que\a"; }
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
RPROMPT=%{$'\e[0;37m'%}\$vcs_info_msg_0_%{$'\e[0m'%}

alias 0clock='echo "  UTC:       $(TZ=UTC date)"; echo "$(tput bold)* Here:      $(date)$(tput sgr0)"; echo "  London:    $(TZ=Europe/London date)"; echo "  Los Angls: $(TZ=America/Los_Angeles date)"; echo "  New York:  $(TZ=America/New_York date)"; echo "  Riyadh:    $(TZ=Asia/Riyadh date)"; echo "  Seoul:     $(TZ=Asia/Seoul date)"'
alias 0fonts="fc-list | sed 's/^.\+: //;s/:.\+$//;s/,.*$//' | sort -u | pr -2 -T"
alias 0ip='wget -q -O - ipinfo.io/ip'
alias 0top-c="ps -Ao pcpu,stat,time,pid,cmd --sort=-pcpu,-time | sed '/^ 0.0 /d'"
alias 0top-d="du -kx | rg -v '\./.+/' | sort -rn"
alias 0top-m='ps -Ao rss,vsz,pid,cmd --sort=-rss,-vsz | awk "{if(\$1>5000)print;}"'
alias 0qmk-build="docker run -e keymap=agaric -e subproject=rev4 -e keyboard=planck --rm -v $HOME/src/qmk_firmware:/qmk:rw edasque/qmk_firmware"
alias 0steam='STEAM_RUNTIME=1 STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 steam'
alias     cp='cp -iv'
alias   diff='diff --color'
alias  dmesg='dmesg --color=always'
alias     mv='mv -iv'
alias     rm='rm -i'
alias     ls='ls --color=auto'
alias      l='ls -A'
alias     ll='ls -lh'
alias    lla='ll -a'
alias    lls='ll -S'
alias    llt='ll -t'
alias     rg="rg --colors 'match:fg:white' --colors 'match:style:nobold' --colors 'path:style:bold' --colors 'line:fg:yellow'"
alias rlwrap='rlwrap'
alias   sudo='sudo '
alias      e='emacsclient -nc'
alias      g='git'
alias      v='vim'
alias   lein='rlwrap lein'
alias pstree='pstree -hnp'
alias   sbcl='rlwrap sbcl'
alias   tome='tome -mgcu'
c() { cd "$@" && \
  { local lim=256 count=$(ls --color=n | wc -l);
    [ $count -gt $lim ] \
    && echo "skipping ls ($count entries > $lim)" \
    || l; }; }
alias     ..='c ..'
alias    ...='c ../..'
alias   ....='c ../../..'
alias  .....='c ../../../..'
0qmk-flash() {
  [ -z "$1" ] \
  && echo "no file given" \
  || { sudo dfu-programmer atmega32u4 erase \
     && sudo dfu-programmer atmega32u4 flash $1 \
     && sudo dfu-programmer atmega32u4 reset; }
}

eval "$(dircolors $HOME/.config/dircolors)"

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
{ mv -f $HOME/.xlog $HOME/.xlog.old >/dev/null 2>/dev/null && \
  xinit >/dev/null 2>$HOME/.xlog; }
