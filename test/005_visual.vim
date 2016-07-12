call vimtest#StartTap()
call vimtap#Plan(15) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
foo bar baz bar
foo bar baz bar
foo bar baz bar
foobar baz bar
.

call LineColPos(4, 1, "normal 1G0wviw&/goo\<cr>")  " <== XXX Account for 2 tests each call XXX
call Is(getline(1), 'foo goo baz bar', "")
call Is(getline(1, '$'), ['foo goo baz bar', 'foo goo baz bar', 'foo goo baz bar', 'foogoo baz bar'], "")

call LineColPos(2, 7, "normal 2G0wcwzoo\<esc>")
call Is(getline(2), 'foo zoo baz bar', "")

normal jVg&
call Is(getline(3), 'foo zoo baz bar', "")
call Is(getline(4), 'foogoo baz bar', "")

call LineColPos(1, 7, "normal 1G0wcwbus\<esc>")
call Is(getline(1), 'foo bus baz bar', "")

call LineColPos(4, 1, "normal 4GVgg&")
call Is(getline(4), 'foobus baz bar', "")

call vimtest#Quit()
