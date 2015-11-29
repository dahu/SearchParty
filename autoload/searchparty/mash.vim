function! searchparty#mash#init()
  if ! exists('b:mash_search_item')
    let b:mash_search_item = matchadd('IncSearch', 'ifyouhavethisstringinyourfileididntthinksomybadreallywerecoolright')
    call matchdelete(b:mash_search_item)
  endif
  if exists(':ShowSearchIndex')
    " Force Shadow Maps to override vim-indexed-search's equivalent maps
    for lhs in ['n', 'N', '#', '*', 'g#', 'g*']
      exec 'silent! nmap  ' . lhs . ' <Plug>SearchPartyMashShadow'.lhs
    endfor
  endif
endfunction

function! searchparty#mash#mash()
  call searchparty#mash#init()
  call searchparty#mash#unmash()
  let b:mash_state = 1
  let b:searching = 1
  if exists('b:mash_use_fow') && b:mash_use_fow
    let b:mash_fow_item = matchadd('MashFOW', '.*', 1)
    call matchadd('IncSearch',  (&ignorecase ? '\c' : '') . @/, 2, b:mash_search_item)
  else
    call matchadd('IncSearch',  (&ignorecase ? '\c' : '') . '\%#'.@/, 2, b:mash_search_item)
  endif
  if exists(':ShowSearchIndex')
    ShowSearchIndex
  endif
  if exists(':AnzuUpdateSearchStatus')
    AnzuUpdateSearchStatus
  endif
endfunction

function! searchparty#mash#unmash()
  let b:mash_state = 0
  try
    call matchdelete(b:mash_search_item)
    call matchdelete(b:mash_fow_item)
  catch /^Vim\%((\a\+)\)\=:E/
  endtry
endfunction

function! searchparty#mash#toggle()
  if ! &hlsearch
    call searchparty#mash#mash()
  else
    call searchparty#mash#unmash()
  endif
  return b:mash_state
endfunction
