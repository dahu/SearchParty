function! searchparty#multiple_replacements#multiply_replace()
  let pos = getpos('.')
  let search = input('Search:')
  let replacements = split(input('Replace:'), '\\\@<! ')
  if len(replacements) > 1
    exe 'norm! Y' . len(replacements) . 'p'
  endif
  for w in replacements
    exe 's/' . search . '/' . w
    exe 'norm! +'
  endfor
  call setpos('.', pos)
endfunction
