set nocompatible
filetype off
syntax on

set number

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()
filetype plugin indent on
