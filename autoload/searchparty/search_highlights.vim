" Toggle Auto Highlight Cursor Word

function! searchparty#search_highlights#toggle_AHCW()
  if exists('#SearchPartyTAHW')
    augroup SearchPartyTAHW
      au!
    augroup END
    augroup! SearchPartyTAHW
    else
      augroup SearchPartyTAHW
        au! CursorHold * call feedkeys("\<Plug>SearchPartyHighlightWord")
      augroup END
    endif
  endfunction


" PrintWithHighlighting

" (Original Code by Jürgen Krämer on vim-dev)

function! searchparty#search_highlights#print(term) range
  let term = a:term
  if term == ''
    let term = @/
  endif
  let lnum = a:firstline
  let lnum_len = len(line('$'))
  for line in getline(a:firstline, a:lastline)
    echohl LineNr
    echon printf("%*s ", lnum_len, lnum)
    echohl none
    let lnum += 1

    let ms = match(line, term)
    let me = matchend(line, term)
    while ms != -1 && ms != me
      echohl none
      echon strpart(line, 0, ms)
      echohl Search
      echon strpart(line, ms, me - ms)
      echohl none
      let line = strpart(line, me)
      let ms = match(line, term)
      let me = matchend(line, term)
    endwhile
    echon line . "\n"
  endfor
endfunction


" Replace Within SearchHighlights

function! searchparty#search_highlights#replace() range
  let save_wrapscan = &ws
  let save_gdefault = &gd
  set nows
  set nogd
  let mtch = @/
  let srch = input('Search: /')
  let repl = input('Replace: /')
  let glbl = input('All? [gy]==yes ') =~# '[yg]' ? 'g' : ''

  if srch == ''
    let srch = mtch
  endif

  " mark the matches
  exe 'normal! ' . a:firstline . 'gg0'
  let counter = Series(0, 1, '%03d')
  let found = search(mtch, 'cW')
  while found && (found <= a:lastline)
    let c = counter.next()
    exe "normal! iSHR>_" . c . "\x02\<esc>"
    call search(mtch, 'ceW')
    exe "normal! a\x02SHR<_" . c . "\<esc>"
    let found = search(mtch, 'cW')
  endwhile

  " sweep the marks
  exe 'normal! ' . a:firstline . 'gg0'
  let counter = Series(0, 1, '%03d')
  let c = counter.next()
  let found = search("SHR>_" . c . "\x02.", 'ceW')
  while found
    try
      silent! exe 'normal! v/' . mtch . '\ze.SHR<_' . c . "/e\<cr>l\<esc>"
    catch /^Vim\%((\a\+)\)\=:E385/
      break
    endtry
    exe 'silent! s/\m\%V' . srch . '\m\%V/' . repl . '/e' . glbl
    call histdel('/', -1)
    let c = counter.next()
    let found = search("SHR>_" . c . "\x02.", 'ceW')
  endwhile

  " remove marks
  silent! exe a:firstline . ',' . a:lastline . 's/SHR>_\d\{3}.//ge'
  silent! exe a:firstline . ',' . a:lastline . 's/.SHR<_\d\{3}//ge'

  let &ws = save_wrapscan
  let &gd = save_gdefault
  let @/ = mtch
endfunction
