" Normal Mode
nmap          <leader>md      <Plug>SearchPartyDeleteMatch
nmap <silent> <leader>?       <Plug>SearchPartyFindLiteralBkwd
nmap <silent> <leader>/       <Plug>SearchPartyFindLiteralFwd
nmap <silent> <c-l>      <c-l><Plug>SearchPartyHighlightClear
nmap <silent> <c-Bslash>      <Plug>SearchPartyHighlightToggle
nmap <silent> <leader>g*      <Plug>SearchPartyHighlightWORD
nmap <silent> <leader>*       <Plug>SearchPartyHighlightWord
nmap          <leader>mf      <Plug>SearchPartyMashFOWToggle
nmap <silent> <leader>mp      <Plug>SearchPartyMultipleReplace
nmap <silent> <leader>ma      <Plug>SearchPartySearchHighlightReplace
nmap          <leader>mm      <Plug>SearchPartySetMatch<CR>
nmap <silent> <leader>ms      <Plug>SearchPartySetSearch
nmap <silent> <leader>mh      <Plug>SearchPartyToggleAutoHighlightWord

" Visual Mode

xmap <silent> <leader>*       <Plug>SearchPartyHighlightVisual
xmap <silent> <leader>ma      <Plug>SearchPartySearchHighlightReplace
xmap          g&              <Plug>SearchPartyVisualChangeAll
xmap          gg&             <Plug>SearchPartyVisualChangeAllBare
xmap <silent> *               <Plug>SearchPartyVisualFindNext
xmap <silent> #               <Plug>SearchPartyVisualFindPrev
xmap          &               <Plug>SearchPartyVisualSubstitute
