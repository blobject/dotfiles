syntax on
filetype plugin indent on

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
set backspace=eol,indent,start
set backup backupdir=$HOME/bak/vim
set ignorecase smartcase
set autoindent smartindent
set mouse=a
set number ruler
set paste
set nohlsearch incsearch
set showcmd showmatch
set wrap

"highlight Error           ctermfg=0
"highlight ErrorMsg        ctermfg=0
highlight LineNr ctermfg=7
"highlight SpecialKey      ctermbg=0 ctermfg=10
highlight ExtraWhitespace ctermbg=1
match ExtraWhitespace /\s\+$/
