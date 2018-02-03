export PATH="/usr/local/sbin:$PATH"
PS1="\[\033[1;41;30m\]BASH\[\033[0;0;34m\] \w \[\033[0m\]"
HISTFILE="$HOME/.bashlog"
alias ls='ls --color=auto'
alias l='ls -A'
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -S'
alias llt='ll -t'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -i'
alias v='vim'
c() {
  cd $@ && l
}
alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'
