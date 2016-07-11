let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

let @* = ''
runtime plugin/SearchParty.vim
" Nexus is needed for SearchHighlightReplace
runtime plugin/Nexus.vim

" Have to manually call SPLoadUserMaps() because RunVimTests doesn't seem to be
" triggering the VimEnter autocommand.
" call SPLoadUserMaps()

function! Is(got, expected, description)
  let qgot = string(a:got)
  call vimtap#Is(a:got, a:expected, qgot, a:description)
endfunction

let g:test_count = 0
function! LineColPos(line, col, ...)
  for cmd in a:000
    exec cmd
  endfor
  let g:test_count += 1
  let msg = join(a:000, '|') . '.'
  let l = line('.')
  let c = col('.')
  call Is(l, a:line, 'LineColPos Line, Test ' . g:test_count . ': ' . msg)
  call Is(c, a:col, 'LineColPos Column, Test ' . g:test_count . ': ' . msg)
endfunction

function! VisualMatch(expected)
  call Is(@*, a:expected, 'VisualMatch. Test ' . g:test_count)
endfunction

function! LineMatch(line, expected)
  call Is(getline(a:line), a:expected, 'LineMatch. Test ' . g:test_count)
endfunction
