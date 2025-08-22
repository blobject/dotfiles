! test -t 0 && return

stty -ixon
bind '"\en": menu-complete'
bind '"\ep": menu-complete-backward'

c()
{ cd "$@" && \
  { local lim count
    lim=256
    count=$(ls --color=n | wc -l);
    test "$count" -gt "$lim" \
      && echo "skipping ls ($count entries > "$lim")" \
      || ls -AF --color=auto --time-style=long-iso; }; }

alias ,='c ..'
alias ,,='c ../..'
alias ,,,='c ../../..'
alias ,,,,='c ../../../..'
alias ,,,,,='c ../../../../..'
alias ,,,,,,='c ../../../../../..'
alias ,,,,,,,='c ../../../../../../..'
alias ,,,,,,,,='c ../../../../../../../..'

PS1='\t \w # '

