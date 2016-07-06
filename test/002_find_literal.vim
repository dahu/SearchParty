call vimtest#StartTap()
call vimtap#Plan(4) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
abc* abc xyz ijk
abcd$ abc* xyz ijk lmn
abcd$ xyz
.

call LineColPos(2, 7, "normal 1G0\\/abc*\<cr>")  " <== XXX Account for 2 tests each call XXX
call LineColPos(3, 1, "normal 2G0\\?abcd$\<cr>")

call vimtest#Quit()
