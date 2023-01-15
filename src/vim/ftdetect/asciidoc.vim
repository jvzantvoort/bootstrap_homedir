"--------------------------------------------------------------------------
"
"         FILE:  .vim/plugin/filetypes.vim
"
"  DESCRIPTION:  Some filetype enhancements
"
"      CREATED:  Mon, 30 Dec 2013
"
"--------------------------------------------------------------------------

autocmd BufReadPre,FileReadPre *.asd if &filetype == "" | setlocal ft=asciidoc | endif
autocmd BufReadPre,FileReadPre *.asciidoc if &filetype == "" | setlocal ft=asciidoc | endif


"--------------------------------------------------------------------------
" END
"--------------------------------------------------------------------------
