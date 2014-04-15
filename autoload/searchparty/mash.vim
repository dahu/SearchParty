function! searchparty#mash#mash()
  call searchparty#mash#unmash()
  if exists('b:mash_use_fow') && b:mash_use_fow
    let b:mash_fow_item = matchadd('MashFOW', '.*', 1)
    let b:mash_search_item = matchadd('IncSearch',  (&ignorecase ? '\c' : '') . @/, 2)
  else
    let b:mash_search_item = matchadd('IncSearch',  (&ignorecase ? '\c' : '') . '\%#'.@/, 2)
  endif
endfunction

function! searchparty#mash#unmash()
  try
    call matchdelete(b:mash_search_item)
    call matchdelete(b:mash_fow_item)
  catch /^Vim\%((\a\+)\)\=:E/
  endtry
endfunction
