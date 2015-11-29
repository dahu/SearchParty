let s:match_hist = exists('s:match_hist') ? s:match_hist : []
let s:matches = repeat([0], 6)
let s:match_num = 0

" default match colours now based on https://github.com/romainl/Apprentice
try | silent hi SPM1 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM1 ctermbg=208 ctermfg=238 guibg=#ff8700 guifg=#444444 | endtry

try | silent hi SPM2 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM2 ctermbg=229 ctermfg=238 guibg=#ffffaf guifg=#444444 | endtry

try | silent hi SPM3 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM3 ctermbg=66  ctermfg=238 guibg=#5f8787 guifg=#bcbcbc | endtry

try | silent hi SPM4 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM4 ctermbg=73  ctermfg=238 guibg=#5fafaf guifg=#444444 | endtry

try | silent hi SPM5 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM5 ctermbg=110 ctermfg=238 guibg=#8fafd7 guifg=#444444 | endtry

try | silent hi SPM6 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM6 ctermbg=103 ctermfg=238 guibg=#8787af guifg=#444444 | endtry


try | silent hi MashFOW | catch /^Vim\%((\a\+)\)\=:E411/ | hi MashFOW ctermfg=grey ctermbg=NONE guifg=grey guibg=NONE | endtry

function! searchparty#arbitrary_matches#match()
  if s:matches[s:match_num] != 0
    echom "Warning: Overriding prior match number " . (s:match_num + 1)
  endif
  call inputsave()
  exe "echohl SPM" . (s:match_num + 1)
  let pattern = input("match: ", expand("<cword>"))
  echohl None
  "call inputrestore()
  if pattern == ''
    return
  endif
  if s:matches[s:match_num] != 0
    call matchdelete(s:matches[s:match_num])
  endif
  " use priority 2 so matches overrule FOW
  let s:matches[s:match_num] = matchadd('SPM' . (s:match_num + 1), pattern, 2)
  let s:match_num = (s:match_num + 1) % len(s:matches)
endfunction

function! searchparty#arbitrary_matches#match_delete(...)
  if a:0
    let num = (a:1 - 1)
  else
    call searchparty#arbitrary_matches#match_list(0)
    let num = input("Remove match: ")
    if empty(num)
      return
    endif
    if num =~ '^\d\+$'
      let num -= 1
    endif
  endif
  if num =~ '^\d\+$'
    if get(s:matches, num, 0) != 0
      call matchdelete(s:matches[num])
      let s:matches[num] = 0
    endif
  else
    let matches = map(filter(searchparty#arbitrary_matches#getmatches(), 'v:val[1] =~ "' . escape(num, '"\\') . '"'), 'matchstr(v:val[0], "\\d$")')
    for n in matches
      let num = n - 1
      call matchdelete(s:matches[num])
      let s:matches[num] = 0
    endfor
  endif
endfunction

function! searchparty#arbitrary_matches#getmatches()
  return map(filter(getmatches(), 'v:val["group"] =~ "SPM"'), '[v:val["group"], v:val["pattern"]]')
endfunction

function! searchparty#arbitrary_matches#match_list(...)
  let matches = map(searchparty#arbitrary_matches#getmatches(), '[v:val[0], substitute(v:val[0], "SPM", "Search Party Match #", "") . " = " . v:val[1]]')
  for match in matches
    exe "echohl " . match[0]
    echo match[1]
    echohl None
  endfor
  if !a:0 || a:1
    echo "Next Search Party Match Number: " . (s:match_num + 1)
  endif
endfunction

function! searchparty#arbitrary_matches#match_number(num)
  let num = a:num
  if (num < 1) || (num > len(s:matches))
    echom "Invalid Search Party Match Number: " . num
  endif
  let s:match_num = (a:num - 1)
  echom "Search Party Match Number: " . num
endfunction
