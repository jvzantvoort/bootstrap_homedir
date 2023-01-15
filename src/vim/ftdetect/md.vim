
autocmd BufReadPre,FileReadPre *.md if &filetype == "" | setlocal ft=md | endif
