syntax on
set number
set nocompatible
filetype off
filetype plugin indent on
set backspace=indent,eol,start

" Always show statusline
source $PLPATH/powerline/bindings/vim/plugin/powerline.vim
set laststatus=2
"
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
call vundle#end()
