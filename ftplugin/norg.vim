autocmd BufRead,BufNewFile *.norg setlocal spell
setlocal tabstop=4 noexpandtab shiftwidth=4
setlocal spelllang=en_us,cjk
inoremap <F3> <c-g>u<Esc>[s1z=`]a<c-g>u
