call vimtest#StartTap()
call vimtap#Plan(4) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc(*) xyz 1
abcd abc abc(*) xyz ijk lmn
abcd xyz
.

call LineColPos(1, 1, 'normal 1G0\*')  " <== XXX Account for 2 tests each call XXX
call Is(@/, '\<abc\>', "")

exe "normal \\msabcd\<cr>"
call Is(@/, 'abcd', "")

call vimtest#Quit()
