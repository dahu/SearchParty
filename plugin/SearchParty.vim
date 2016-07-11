""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extended search tools for Vim
" Maintainers:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.7
" Description:	Commands and maps for extended searches in Vim
" License:	Vim License (see :help license)
" Website:	https://github.com/dahu/SearchParty
"
" See SearchParty.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help SearchParty
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:SearchParty_version = '0.7'   " Allow custom user maps

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard {{{2
" uncomment after plugin development
"if exists("g:loaded_SearchParty")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
let g:loaded_SearchParty = 1
let s:plugin_root = expand('<sfile>:p:h:h')

" Global Options: {{{1

if !exists('g:searchparty_visual_find_sets_search')
  let g:searchparty_visual_find_sets_search = 0
endif

if !exists('g:searchparty_load_user_maps')
  let g:searchparty_load_user_maps = 1
endif

" Load User Maps: {{{1

function! s:Carp(msg)
  echohl  WarningMsg
  echomsg a:msg
  echohl  None
  return  0
endfunction

function! SPLoadUserMaps()
  if ! g:searchparty_load_user_maps
    return
  endif
  let sp_default_maps_file = s:plugin_root . '/searchparty_default_maps.vim'
  let sp_user_maps_file    = s:plugin_root . '/searchparty_user_maps.vim'
  if ! filereadable(sp_user_maps_file)
    if ! filereadable(sp_default_maps_file)
      return s:Carp('SPLoadUserMaps: Cannot find default maps file (' . sp_default_maps_file .')')
    endif
    if writefile(readfile(sp_default_maps_file), sp_user_maps_file) == -1
      return s:Carp('SPLoadUserMaps: Cannot copy default maps to user maps file (' . sp_user_maps_file .')')
    endif
  endif

  for line in readfile(sp_user_maps_file)
    if line =~ '^\s*\(".*\)\?$'
      continue
    endif
    if line !~ '^\s*.\(nore\)\?map'
      call s:Carp('SPLoadUserMaps: Not a map command! (' . line . ')')
      continue
    endif
    let lhs  = matchstr(line, '\c<unique>\s*\(<silent>\)\?\s*\zs\S\+')
    let plug = matchstr(line, '\c<plug>\S\+')
    let mode = matchstr(line, '^\s*\zs.')
    let existing = maparg(lhs, mode)
    if existing != ''
      call s:Carp('SPLoadUserMaps: Mapping ' . lhs . ' already mapped to ' . existing)
      continue
    endif
    if !hasmapto(plug, mode)
      exe line
    endif
  endfor
endfunction

" Autocommands: {{{1

augroup SearchPartySearching
  au!
  au VimEnter * call SPInitialiseSearchMaps()
  au BufEnter * let b:searching = 0
  au CursorHold * call SPAfterSearch()
augroup END

function! SPInitialiseSearchMaps()
  let rhs = ':call searchparty#mash#unmash()<bar>let b:searching=1'
  if exists(':ShowSearchIndex')
    let ssi = '<bar>ShowSearchIndex<cr>'
  else
    let ssi = '<cr>'
  endif
  exe 'nnoremap <Plug>SearchPartySearchFwd '  . rhs . ssi . '/'
  exe 'nnoremap <Plug>SearchPartySearchBkwd ' . rhs . ssi . '?'
  nmap / <Plug>SearchPartySearchFwd
  nmap ? <Plug>SearchPartySearchBkwd
  call SPLoadUserMaps()
endfunction


" After Search Callbacks: {{{1

function! SPAfterSearch()
  if exists('b:searching') && b:searching
    call searchparty#mash#mash()
    for x in range(10)
      if exists('*AfterSearch_' . x)
        call call('AfterSearch_' . x, [])
      endif
    endfor
  endif
  let b:searching = 0
endfunction

" Plug Maps: {{{1

" Literal Search: {{{2

nnoremap <silent> <Plug>SearchPartyFindLiteralFwd
      \ :<C-U>call searchparty#literal_search#find_literal(1)<CR>

nnoremap <silent> <Plug>SearchPartyFindLiteralBkwd
      \ :<C-U>call searchparty#literal_search#find_literal(0)<CR>

" SearchParty Arbitrary Matches: {{{2

nnoremap <Plug>SearchPartySetMatch
      \ :call searchparty#arbitrary_matches#match()<cr>

nnoremap <Plug>SearchPartyDeleteMatch
      \ :call searchparty#arbitrary_matches#match_delete()<CR>

command! -bar -nargs=0 SearchPartyMatchList
      \ call searchparty#arbitrary_matches#match_list()

command! -bar -nargs=? SearchPartyMatchDelete
      \ call searchparty#arbitrary_matches#match_delete(<args>)

command! -bar -nargs=1 SearchPartyMatchNumber
      \ call searchparty#arbitrary_matches#match_number(<args>)

" MASH Movement Activated Search Highlight: {{{2

hi MashFOW ctermfg=black ctermbg=NONE guifg=black guibg=NONE

augroup SP_MASH
  au!
  autocmd BufRead,BufNew * let b:mash_use_fow = 0
augroup END

" Shadow Maps
for lhs in ['n', 'N', '#', '*', 'g#', 'g*']
  exec 'nnoremap <silent> <Plug>SearchPartyMashShadow' . lhs . ' ' . lhs
        \ . ':call searchparty#mash#mash()<CR>'
  if !hasmapto('<Plug>SearchPartyMashShadow' . lhs)
    exec 'silent! nmap <unique> ' . lhs . ' <Plug>SearchPartyMashShadow'.lhs
  endif
endfor

nnoremap <silent> <Plug>SearchPartyMashFOWToggle
      \ :let b:mash_use_fow = b:mash_use_fow ? 0 : 1<CR>
      \:call searchparty#mash#mash()<CR>

" backwards compatible to my deprecated vim-MASH plugin
nmap <silent> <Plug>MashFOWToggle  <Plug>SearchPartyMashFOWToggle

" Multiple Replacements: {{{2

nnoremap <Plug>SearchPartyMultipleReplace
      \ :call searchparty#multiple_replacements#multiply_replace()<CR>

" Search Highlighting: {{{2

" Temporarily clear highlighting
nnoremap <Plug>SearchPartyHighlightClear
      \ :let b:mash_use_fow = 0<cr>
      \:call searchparty#mash#unmash()<bar>noh<cr>

" Toggle search highlighting
nnoremap <Plug>SearchPartyHighlightToggle :let &hlsearch = searchparty#mash#toggle()<bar>set hlsearch?<cr>

" Highlight all occurrences of word under cursor
nnoremap <Plug>SearchPartyHighlightWord
      \ :let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<cr>viwo<esc>

" Highlight all occurrences of visual selection
xnoremap <Plug>SearchPartyHighlightVisual
      \ :<c-U>let @/=searchparty#visual#element()<bar>set hlsearch<cr>

" Highlight all occurrences of WORD under cursor
nnoremap <Plug>SearchPartyHighlightWORD
      \ :let @/='\V'.escape(expand('<cWORD>'), '\\')<bar>set hlsearch<cr>viWo<esc>

" Manual Search Term From Input
nnoremap <Plug>SearchPartySetSearch
      \ :let @/=input("set search: ")<bar>set hlsearch<cr>

" Visual Search And Replace: {{{2

" The default expected mappings:
" Use * and # in visual mode to search for visual selection
" Use & in visual mode to prime a substitute based on visual selection
" Use g& in visual mode to repeat the prior change

xnoremap <Plug>SearchPartyVisualFindNext      :<c-u>call searchparty#visual#find('/')<cr>
xnoremap <Plug>SearchPartyVisualFindPrev      :<c-u>call searchparty#visual#find('?')<cr>
xnoremap <Plug>SearchPartyVisualSubstitute    :<c-u>%s/<c-r>=searchparty#visual#element()<cr>
xnoremap <Plug>SearchPartyVisualChangeAll     :s/\<<c-r>-\>/\=@./g<cr>
xnoremap <Plug>SearchPartyVisualChangeAllBare :s/<c-r>-/\=@./g<cr>

" Toggle Auto Highlight Cursor Word: {{{2

nnoremap <Plug>SearchPartyToggleAutoHighlightWord
      \ :call searchparty#search_highlights#toggle_AHCW()<CR>

" Print With Highlighting: {{{2

command! -range=% -nargs=* P
      \ <line1>,<line2>call searchparty#search_highlights#print(<q-args>)

" Replace Within Search Highlights: {{{2

noremap <Plug>SearchPartySearchHighlightReplace
      \ :call searchparty#search_highlights#replace()<CR>

command! -range=% -nargs=0 SearchHighlightReplace
      \ <line1>,<line2>call searchparty#search_highlights#replace()

" Search Within A Range: {{{2

command! -range=% -nargs=* RSearch
      \ exe '/\%(\%>'.(<line1>-1).'l\%<'.(<line2>+1).'l\)\&\%(<args>\)/'


" Teardown:{{{1
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
