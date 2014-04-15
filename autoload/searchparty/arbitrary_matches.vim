let s:match_hist = exists('s:match_hist') ? s:match_hist : []
let s:matches = repeat([0], 6)
let s:match_num = 0

" default match colours
try | silent hi SPM1 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM1 ctermbg=1 guibg=red    | endtry
try | silent hi SPM2 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM2 ctermbg=2 guibg=green  | endtry
try | silent hi SPM3 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM3 ctermbg=3 guibg=yellow | endtry
try | silent hi SPM4 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM4 ctermbg=4 guibg=blue   | endtry
try | silent hi SPM5 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM5 ctermbg=5 guibg=purple | endtry
try | silent hi SPM6 | catch /^Vim\%((\a\+)\)\=:E411/ | hi SPM6 ctermbg=6 guibg=cyan   | endtry
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
  " use priority -1 so normal searches show above SP matches
  let s:matches[s:match_num] = matchadd('SPM' . (s:match_num + 1), pattern, -1)
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
    let num -= 1
  endif
  if get(s:matches, num, 0) != 0
    call matchdelete(s:matches[num])
    let s:matches[num] = 0
  endif
endfunction

function! searchparty#arbitrary_matches#match_list(...)
  let matches = map(filter(getmatches(), 'v:val["group"] =~ "SPM"'), '[v:val["group"], substitute(v:val["group"], "SPM", "Search Party Match #", "") . " = " . v:val["pattern"]]')
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
