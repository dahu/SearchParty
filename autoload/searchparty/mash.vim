function! s:init()
  if ! exists('b:mash_search_item')
    let b:mash_search_item = matchadd('IncSearch', 'ifyouhavethisstringinyourfileididntthinksomybadreallywerecoolright')
    call matchdelete(b:mash_search_item)
  endif
endfunction

function! searchparty#mash#mash()
   call s:init()
  call searchparty#mash#unmash()
  if exists('b:mash_use_fow') && b:mash_use_fow
    let b:mash_fow_item = matchadd('MashFOW', '.*', 1)
    call matchadd('IncSearch',  (&ignorecase ? '\c' : '') . @/, 2, b:mash_search_item)
  else
    call matchadd('IncSearch',  (&ignorecase ? '\c' : '') . '\%#'.@/, 2, b:mash_search_item)
  endif
endfunction

function! searchparty#mash#unmash()
  try
    call matchdelete(b:mash_search_item)
    call matchdelete(b:mash_fow_item)
  catch /^Vim\%((\a\+)\)\=:E/
  endtry
endfunction
