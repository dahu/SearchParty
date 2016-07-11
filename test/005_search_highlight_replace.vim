call vimtest#StartTap()
call vimtap#Plan(1) " <== XXX  Keep plan number updated.  XXX
"call vimtap#Diag('Test')
append
192.168.1.11 localhost
192.168.1.11 localhost
192.168.1.11 localhost
192.168.1.11 localhost
.

exe 'normal 1G0\mp' . "1\\ze \<cr>2 3 4 5\<cr>"
call Is(getline(1,'$'), ['192.168.1.1 localhost', '192.168.1.2 localhost', '192.168.1.3 localhost', '192.168.1.4 localhost', '192.168.1.5 localhost'], "")

call vimtest#Quit()
