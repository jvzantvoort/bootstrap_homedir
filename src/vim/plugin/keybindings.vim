"--------------------------------------------------------------------------
"
"         FILE:  .vim/plugin/keybindings.vim
"
"  DESCRIPTION:  Some usefull keybindings
"
"      CREATED:  Mon, 30 Dec 2013
"
"--------------------------------------------------------------------------

" when editing muliple file with :sp you can switch between them
" with <ctrl>-j and <ctrl>-k
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

map <F6> :setlocal spell! spelllang=en_us<cr>

map <s-LEFT> :vertical resize +5 <Cr>
map <s-RIGHT> :vertical resize -5 <Cr>
map <s-UP> :resize +5 <Cr>
map <s-DOWN> :resize -5 <Cr>

nmap <leader>et :tabe %%
nmap <leader>n  :tabn<cr>
nmap <leader>p  :tabp<cr>

if version >= 700
  cnoremap %% <C-R>=expand('%:h').'/'<cr>
  nmap <leader>et :tabe %%
  nmap <leader>n  :tabn<cr>
  nmap <leader>p  :tabp<cr>
else
  cnoremap %% <C-R>=expand('%:h').'/'<cr>
  nmap <leader>et :sp %%
  nmap <leader>n  :wincmd j<cr>
  nmap <leader>p  :wincmd k<cr>
endif

nmap <leader>t :call TakeNote()<CR>

nnoremap <leader>o :NERDTreeToggle<CR>

"--------------------------------------------------------------------------
" END
"--------------------------------------------------------------------------
