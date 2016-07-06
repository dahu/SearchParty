call vimtest#StartTap()
call vimtap#Plan(46) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc xyz ijk
abcd abcd xyz ijk lmn
abcde xyz
.

call LineColPos(1, 5, 'normal 1G0*')  " <== XXX Account for 2 tests each call XXX
call LineColPos(1, 1, 'normal *')

call LineColPos(1, 7, "normal 1G0viw*")
call LineColPos(2, 3, 'normal *')
call LineColPos(2, 8, 'normal *')
exe "normal \<esc>"

call LineColPos(1, 5, 'normal 1G0#')
call LineColPos(1, 1, 'normal #')

call LineColPos(3, 3, 'normal 1G0viw#')
call LineColPos(2, 8, 'normal #')
call LineColPos(2, 3, 'normal #')
exe "normal \<esc>"

call LineColPos(1, 5, 'normal 1G0g*')
call LineColPos(2, 1, 'normal g*')
call LineColPos(2, 6, 'normal g*')
call LineColPos(3, 1, 'normal g*')
call LineColPos(3, 1, 'normal g*')

call LineColPos(3, 1, 'normal 1G0g#')
call LineColPos(3, 1, 'normal g#')

call LineColPos(2, 11, 'normal 1G09|*')
" RunVimTests isn't setting @/ on * ?!
let @/ = '\<xyz\>'
call LineColPos(3, 7, 'normal n')
call LineColPos(1, 9, 'normal n')
call LineColPos(3, 7, 'normal N')
call LineColPos(2, 11, 'normal N')
call LineColPos(1, 9, 'normal N')

call vimtest#Quit()
