call vimtest#StartTap()
call vimtap#Plan(9) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc abc(*) xyz 1
abcd abc abc(*) xyz ijk lmn
abcd xyz
.

call LineColPos(1, 1, 'normal 1G0\*')  " <== XXX Account for 2 tests each call XXX
call VisualMatch("abc")

call LineColPos(2, 1, 'normal 2G0\*')
call VisualMatch("abcd")

call LineColPos(2, 10, 'normal 1G0w\g*n')
call VisualMatch('abc(*)')

call vimtest#Quit()
