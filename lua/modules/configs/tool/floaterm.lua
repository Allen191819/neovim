return function()
	vim.g.floaterm_width = 0.8
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_title = ""
	vim.g.floaterm_borderchars = {
		"─",
		"│",
		"─",
		"│",
		"╭",
		"╮",
		"╯",
		"╰",
	}
	vim.g.floaterm_keymap_new = ""
	vim.g.floaterm_keymap_prev = ""
	vim.g.floaterm_keymap_next = ""
	vim.g.floaterm_keymap_toggle = "<F12>"
	vim.g.floaterm_autoclose = 0
	vim.cmd([[
		command! Ranger FloatermNew --title=ranger --autoclose=1 ranger
		command! LazyGit FloatermNew --width=0.95 --height=0.95 --title=lazygit --autoclose=1 lazygit
		command! Ipython FloatermNew --position=right --width=0.5 --wintype=vsplit --name=repl --title=ipython ipython
		command! Ghci FloatermNew --position=right --width=0.5 --wintype=vsplit --name=repl --title=ghci ghci
		command! Scheme FloatermNew --position=right --width=0.5 --wintype=vsplit --name=repl --title=scheme chez
		command! Lua FloatermNew --position=right --width=0.5 --wintype=vsplit --name=repl --title=lua lua
		command! Glow FloatermNew --title=glow --autoclose=1 glow
	]])
end
