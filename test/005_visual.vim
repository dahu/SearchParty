call vimtest#StartTap()
call vimtap#Plan(8) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
foo bar baz bar
foo bar baz bar
foo bar baz bar
.

call LineColPos(3, 1, "normal 1G0wviw&/goo\<cr>")  " <== XXX Account for 2 tests each call XXX
call Is(getline(1), 'foo goo baz bar', "")
call Is(getline(1, '$'), ['foo goo baz bar', 'foo goo baz bar', 'foo goo baz bar'], "")

call LineColPos(2, 7, "normal 2G0wcwzoo\<esc>")  " <== XXX Account for 2 tests each call XXX
call Is(getline(2), 'foo zoo baz bar', "")

normal jVg&
call Is(getline(3), 'foo zoo baz bar', "")

call vimtest#Quit()
