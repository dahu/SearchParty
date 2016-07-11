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
