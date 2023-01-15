" https://github.com/wvanlint/twf/
" Install:
"   go get -u github.com/wvanlint/twf/cmd/twf
function! Twf()
  let temp = tempname()
  execute 'silent ! twf ' . @% . ' > ' . temp
  redraw!
  try
    let out = filereadable(temp) ? readfile(temp) : []
  finally
    silent! call delete(temp)
  endtry
  if !empty(out)
    execute 'edit! ' . out[0]
  endif
endfunction

nnoremap <silent> <Space>t :call Twf()<CR>
