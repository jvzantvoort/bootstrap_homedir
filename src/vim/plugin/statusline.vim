"--------------------------------------------------------------------------
"
"         FILE:  .vim/plugin/statusline.vim
"
"  DESCRIPTION:  Some status line coolness
"
"      CREATED:  Mon, 30 Dec 2013
"
"--------------------------------------------------------------------------

set statusline= " clear the statusline for when vimrc is reloaded
set statusline+=%f\ " file name
set statusline+=%h%m%r%w " flags
set statusline+=[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=%= "left/right separator
set statusline+=%b,0x%-8B\ " current char
set statusline+=%c,%l/ "cursor column/total lines
set statusline+=%L\ %P "total lines/percentage in file
set ls=2

"--------------------------------------------------------------------------
" END
"--------------------------------------------------------------------------
