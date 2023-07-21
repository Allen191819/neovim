return function()
	vim.cmd([[
		let g:VM_theme                      = 'ocean'
		let g:VM_highlight_matches          = 'underline'
		let g:VM_maps                       = {}
		let g:VM_maps['Find Under']         = '<C-n>'
		let g:VM_maps['Find Subword Under'] = '<C-n>'
		let g:VM_maps['Select All']         = '<C-d>'
		let g:VM_maps['Select h']           = '<C-Left>'
		let g:VM_maps['Select l']           = '<C-Right>'
		let g:VM_maps['Add Cursor Up']      = '<C-Up>'
		let g:VM_maps['Add Cursor Down']    = '<C-Down>'
		let g:VM_maps['Add Cursor At Pos']  = '<C-x>'
		let g:VM_maps['Add Cursor At Word'] = '<C-w>'
		let g:VM_maps['Remove Region']      = 'q'
		]])
end
