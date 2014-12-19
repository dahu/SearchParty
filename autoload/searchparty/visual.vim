function! searchparty#visual#element()
  let select = visualmode()
  let old_a = @a
  silent exe 'normal! `<' . select . '`>"ay'
  let term = substitute(escape(@a, '\/.*$^~[]'), "\n", '\\n', 'g')
  let @a = old_a
  return term
endfunction

function! searchparty#visual#find(search_type)
  let term = searchparty#visual#element()
  let flags = (a:search_type == '/' ? '' : 'b') . 'w'
  let old_sc = &smartcase
  set nosmartcase
  if search(term, flags)
    silent! exe 'normal! ' . visualmode() . '/' . term . "/e\<cr>"
  endif
  let &sc = old_sc
endfunction
