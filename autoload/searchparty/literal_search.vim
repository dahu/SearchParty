" Our private history.
let s:search_literal_hist =
      \ exists('s:search_literal_hist') ? s:search_literal_hist : []

function! searchparty#literal_search#find_literal(...)
  " First, empty the input history.
  call histdel('input')
  " next, add our own history.
  call map(copy(s:search_literal_hist), 'histadd("input", v:val)')
  " Prepare a prompt.
  let prompt = 'Literal Search ' . (a:0 && a:1 ? '/' : '?')
  " Search forward or backward.
  let search_cmd = a:0 && a:1 ? '/' : '?'
  " Get user's input.
  let input = input(prompt)
  "Thanks to \V only slashes and, backslashes or question marks need to be escaped.
  let escaped = a:0 && a:1 ? escape(input, '\/') : escape(input, '\?')
  " Allow control chars.
  call join(map(split(escaped, '\zs'), 'v:val =~# [[:control:]] ? "\<C-V>".v:val : v:val'))
  if empty(input)
    " Nothing to do here.
    return
  endif
  " Perform the search after we're done.
  call feedkeys("\<Esc>" . search_cmd . "\\V" . escaped . "\<CR>", 'n')
  call feedkeys(":call searchparty#mash#mash()\<CR>\<C-L>", 'n')
  "Add current string to our private history.
  call add(s:search_literal_hist, input)
endfunction
