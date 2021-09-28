" for Vbundle
set nocompatible        " use vim defaults instead of 100% vi compatibility
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on


" ----- Below are my personal configurations -----
syntax enable 		    " enbale syntax
colorscheme molokai 	" molokai colorshceme
set backspace=indent,eol,start  " allow to delete those characters

set tabstop=4       	" number of visual spaces per TAB
set softtabstop=4   	" number of spaces in tab when editing
set expandtab       	" tabs are spaces
set shiftwidth=4	    " use 4 spaces when indenting with '>'

set autoindent          " apply the indentation of the current line to the next
set smartindent         " syntax/style-dependent indent, must have autoindent enabled

set relativenumber      " show relative line numbers
set number 		        " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line

" filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" highlight the 80-th column
set colorcolumn=81
highlight ColorColumn ctermbg=lightblue

highlight Visual ctermbg=grey                   " highlight selection

autocmd FileType make setlocal noexpandtab      " do not expand tab for makefile
autocmd FileType latex setlocal autoindent off
autocmd FileType latex setlocal smartindent off
" ----- End of my personal configurations -----

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p



" ----- vim-plug -----
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

let g:deoplete#enable_at_startup = 1


call plug#end()
