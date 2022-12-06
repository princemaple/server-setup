set -e

cat << EOF >> ~/.vimrc
set nu
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set ruler

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set hlsearch
set incsearch

set showmatch
set mat=2

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
EOF
