return function()
	vim.cmd([[
	let g:expand_region_text_objects = {
		\ 'iw'  :0,
		\ 'iW'  :0,
		\ 'i"'  :1,
		\ 'i''' :1,
		\ 'i]'  :1,
		\ 'ib'  :1,
		\ 'iB'  :1,
		\ 'ip'  :1,
		\ 'iT'  :1,
		\ 'il'  :1,
		\ 'ix'  :1,
		\ }
		]])
end
