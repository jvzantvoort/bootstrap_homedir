" plugins {{{
let s:pluginCFG = expand('~/.vim/plugins.vim')

if filereadable(s:pluginCFG)
    exe "source " . s:pluginCFG
endif
" }}}

" local override {{{
let s:localCFG = expand('~/.vim/local.vim')

if filereadable(s:localCFG)
    exe "source " . s:localCFG
endif
" }}}
" vim: foldmethod=marker
