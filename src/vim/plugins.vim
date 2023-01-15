"--------------------------------------------------------------------------
"
"         FILE:  .vim/plugins.vim
"
"  DESCRIPTION:  Plugins used in this tragedy
"
"      CREATED:  Fri, 11 Aug 2017
"
"--------------------------------------------------------------------------

" test if we have vundle
" --------------------------------------
let s:vundledir = expand('~/.vim/bundle/Vundle.vim')
let s:plugsindir = expand('~/.vim/plugins/')
if !isdirectory(s:vundledir)
  finish
endif

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
if (has('win32') || has('win64'))
  set rtp+=$HOME/.vim
endif
call vundle#begin()

function! LoadConfigFile(configfile)
  exe "source " . s:plugsindir .  a:configfile
endfunction

if version >= 800

  " Add language-server-protocol
  Plugin 'prabirshrestha/asyncomplete.vim'
  Plugin 'prabirshrestha/async.vim'
  Plugin 'prabirshrestha/vim-lsp'
  Plugin 'prabirshrestha/asyncomplete-lsp.vim'

endif

Plugin 'VundleVim/Vundle.vim.git'

" vim: interpret a file by function and cache file automatically
Plugin 'MarcWeber/vim-addon-mw-utils.git'

" Some utility functions for VIM
Plugin 'tomtom/tlib_vim.git'

Plugin 'seeamkhan/robotframework-vim'

" snipMate.vim aims to be a concise vim script that implements some of
" TextMate's snippets features in Vim.
Plugin 'garbas/vim-snipmate.git'

" A tree explorer plugin for vim.
Plugin 'scrooloose/nerdtree.git'

Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'

" Plugin 'kien/ctrlp.vim'
Plugin 'Glench/Vim-Jinja2-Syntax'

Plugin 'nvie/vim-flake8'

Plugin 'chase/vim-ansible-yaml'

Plugin 'cespare/vim-toml'

Plugin 'fatih/vim-go'

Plugin 'hashivim/vim-terraform'

" Syntax highlighting and icons for nerdtree
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'ryanoasis/vim-devicons'

Plugin 'martinda/Jenkinsfile-vim-syntax'

call vundle#end()
filetype plugin indent on    " required

let g:terraform_fmt_on_save=1
