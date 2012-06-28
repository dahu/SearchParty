""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended search tools for Vim
" Maintainers:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Commands and maps for extended searches in Vim
" Last Change:	2012-06-28
" License:	Vim License (see :help license)
" Location:	plugin/SearchParty.vim
" Website:	https://github.com/dahu/SearchParty
"
" See SearchParty.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help SearchParty
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:SearchParty_version = '0.2'

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

" SearchParty arbitrary matches
try | silent hi SPM1 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM1 ctermbg=1 guibg=red | endtry
try | silent hi SPM2 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM2 ctermbg=2 guibg=green | endtry
try | silent hi SPM3 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM3 ctermbg=3 guibg=yellow | endtry
try | silent hi SPM4 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM4 ctermbg=4 guibg=blue | endtry
try | silent hi SPM5 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM5 ctermbg=5 guibg=purple | endtry
try | silent hi SPM6 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM6 ctermbg=6 guibg=cyan | endtry

let s:matches = repeat([0], 6)
let s:match_num = 0
function! s:Match()
  if s:matches[s:match_num] != 0
    echom "Warning: Overriding prior match number " . (s:match_num + 1)
  endif
  call inputsave()
  exe "echohl SPM" . (s:match_num + 1)
  let pattern = input("match: ", expand("<cword>"))
  echohl None
  "call inputrestore()
  if pattern == ''
    return
  endif
  if s:matches[s:match_num] != 0
    call matchdelete(s:matches[s:match_num])
  endif
  " use priority -1 so normal searches show above SP matches
  exe "let s:matches[s:match_num] = matchadd('SPM" . (s:match_num + 1) . "', pattern, -1)"
  let s:match_num = (s:match_num + 1) % len(s:matches)
endfunction

nnoremap <Plug>SearchPartySetMatch :call <SID>Match()<cr>
  "nmap <unique> <leader>mm :call <SID>Match()<cr>

if !hasmapto('<Plug>SearchPartySetMatch')
  nmap <unique> <leader>mm <Plug>SearchPartySetMatch<CR>
endif

function! SearchPartyMatchDelete(num)
  let num = (a:num - 1)
  if s:matches[num] != 0
    call matchdelete(s:matches[num])
    let s:matches[num] = 0
  endif
endfunction

command! -nargs=1 SearchPartyMatchDelete call SearchPartyMatchDelete(<args>)

function! SearchPartyMatchList()
  let matches = map(filter(getmatches(), 'v:val["group"] =~ "SPM"'), '[v:val["group"], substitute(v:val["group"], "SPM", "Search Party Match #", "") . " = " . v:val["pattern"]]')
  for match in matches
    exe "echohl " . match[0]
    echo match[1]
    echohl None
  endfor
  echo "Next Search Party Match Number: " . (s:match_num + 1)
endfunction

command! -nargs=0 SearchPartyMatchList call SearchPartyMatchList()

function! SearchPartyMatchNumber(num)
  let num = a:num
  if (num < 1) || (num > len(s:matches))
    echom "Invalid Search Party Match Number: " . num
  endif
  let s:match_num = (a:num - 1)
  echom "Search Party Match Number: " . num
endfunction

command! -nargs=1 SearchPartyMatchNumber call SearchPartyMatchNumber(<args>)

" Visual Search & Replace
"-------------------------
" Use * and # in visual mode to search for visual selection
vnoremap <Plug>SearchPartyVisualFindNext   "*y<Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>

vnoremap <Plug>SearchPartyVisualFindPrev   "*y<Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>

" Use & in visual mode to prime a substitute based on visual selection
vnoremap <Plug>SearchPartyVisualSubstitute "*y<Esc>:<c-u>%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/

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

" Manually set Search Term from input
nnoremap <Plug>SearchPartySetSearch :let @/=input("set search: ")<bar>set hlsearch<cr>

if !hasmapto('<Plug>SearchPartySetSearch')
  nmap <unique> <silent> <leader>ms <Plug>SearchPartySetSearch
endif


" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
