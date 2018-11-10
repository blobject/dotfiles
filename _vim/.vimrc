syntax on
filetype plugin indent on

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
set backup backupdir=$HOME/bak/vim
set ignorecase smartcase
set autoindent smartindent
set number ruler
set nohlsearch incsearch
set showcmd showmatch
set wrap

highlight LineNr          ctermfg=7
"highlight LineNr          ctermfg=8 ctermbg=7
"highlight SpecialKey      ctermfg=10 ctermbg=0
"highlight StatusLine      ctermfg=0  ctermbg=14
highlight ExtraWhitespace ctermbg=1
match ExtraWhitespace /\s\+$/
