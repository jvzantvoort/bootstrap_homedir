if did_filetype() " filetype already set..
  finish          " ..don't do these checks
endif

autocmd BufRead,BufNewFile *.irst set filetype=rst
