call plug#begin('~/.vim/plugged')
	Plug 'airblade/vim-gitgutter'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'itchyny/lightline.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'mattn/emmet-vim'
	Plug 'scrooloose/nerdtree'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'tpope/vim-eunuch'
	Plug 'tpope/vim-surround'
	Plug 'w0rp/ale'
	Plug 'morhetz/gruvbox'
call plug#end()

""" Sets
set relativenumber
set nowrap
set relativenumber
silent! colorscheme gruvbox
set background=dark

""" Clip
set clipboard=unnamed
set paste
set go+=a 


""" Maps
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

