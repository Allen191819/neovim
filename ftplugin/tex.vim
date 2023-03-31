autocmd BufRead,BufNewFile *.tex setlocal spell
set spelllang=en_us,cjk
setlocal spell
inoremap <F3> <c-g>u<Esc>[s1z=`]a<c-g>u
