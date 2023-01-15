"--------------------------------------------------------------------------
"
"         FILE:  .vim/plugin/conway.vim
"
"  DESCRIPTION:  Some settings learned from Damian Conway's presentation.
"
"      CREATED:  Mon, 30 Dec 2013
"
"--------------------------------------------------------------------------

exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

"--------------------------------------------------------------------------
" END
"--------------------------------------------------------------------------
