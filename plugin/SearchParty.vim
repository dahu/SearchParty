""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended search tools for Vim
" Maintainers:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Commands and maps for extended searches in Vim
" Last Change:	2012-05-12
" License:	Vim License (see :help license)
" Location:	plugin/SearchParty.vim
" Website:	https://github.com/dahu/SearchParty
"
" See SearchParty.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help SearchParty
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:SearchParty_version = '0.1'

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development
"if exists("g:loaded_SearchParty")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_SearchParty = 1

" Options: {{{1
"if !exists('g:somevar')
  "let g:somevar = 0
"endif

" Literal Search
" --------------
" Our private history.
let s:history = exists('s:history') ? s:history : []

function! s:FindLiteral()
  " First, empty the input history.
  call histdel('input')
  " next, add our own history.
  call map(copy(s:history), 'histadd("input", v:val)')
  " Get user's input.
  let input = input('g/')
  if empty(input)
    " Nothing to do here.
    return
  endif
  " Perform the search after we're done. Thanks to \V only the backslashes
  " need to be escaped.
  call feedkeys("\<Esc>/\\V".escape(input, '\')."\<CR>", 'n')
  "Add current string to our private history.
  call add(s:history, input)
endfunction

nnoremap <silent> <Plug>SearchPartyFindLiteral :<C-U>call <SID>FindLiteral()<CR>

if !hasmapto('<Plug>SearchPartyFindLiteral')
  nmap <unique> <silent> g/ <Plug>SearchPartyFindLiteral
endif

" Visual Search & Replace
"-------------------------
" Use * and # in visual mode to search for visual selection
vnoremap <Plug>SearchPartyVisualFindNext   <Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>

vnoremap <Plug>SearchPartyVisualFindPrev   <Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>

" Use & in visual mode to prime a substitute based on visual selection
vnoremap <Plug>SearchPartyVisualSubstitute <Esc>:<c-u>%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/

if !hasmapto('<Plug>SearchPartyVisualFindNext')
  vmap <unique> <silent> * <Plug>SearchPartyVisualFindNext
endif

if !hasmapto('<Plug>SearchPartyVisualFindPrev')
  vmap <unique> <silent> # <Plug>SearchPartyVisualFindPrev
endif

if !hasmapto('<Plug>SearchPartyVisualSubstitute')
  vmap <unique> & <Plug>SearchPartyVisualSubstitute
endif

" Search Highlighting
"---------------------

" Temporarily clear highlighting
nnoremap <Plug>SearchPartyHighlightClear :nohlsearch<cr><c-l>

if !hasmapto('<Plug>SearchPartyHighlightClear')
  nmap <unique> <silent> <c-l> <Plug>SearchPartyHighlightClear
endif

" Toggle search highlighting
nnoremap <Plug>SearchPartyHighlightToggle :set invhlsearch hlsearch?<cr>

if !hasmapto('<Plug>SearchPartyHighlightToggle')
  nmap <unique> <silent> <c-Bslash> <Plug>SearchPartyHighlightToggle
endif

" Highlight all occurrences of word under cursor
nnoremap <Plug>SearchPartyHighlightWord :let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<cr>viwo<esc>

if !hasmapto('<Plug>SearchPartyHighlightWord')
  nmap <unique> <silent> <leader>* <Plug>SearchPartyHighlightWord
endif

" Highlight all occurrences of WORD under cursor
nnoremap <Plug>SearchPartyHighlightWORD :let @/=expand('<cWORD>')<bar>set hlsearch<cr>

if !hasmapto('<Plug>SearchPartyHighlightWORD')
  nmap <unique> <silent> <leader>g* <Plug>SearchPartyHighlightWORD
endif



" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
