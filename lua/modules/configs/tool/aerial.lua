return function()
	require("aerial").setup({
		-- Priority list of preferred backends for aerial.
		-- This can be a filetype map (see :help aerial-filetype-map)
		backends = { "treesitter", "lsp", "markdown" },
		close_automatic_events = { "unfocus" },
		default_bindings = true,
		disable_max_lines = 1000,
		filter_kind = {
			"Class",
			"Constructor",
			"Enum",
			"Function",
			"Interface",
			"Module",
			"Method",
			"Struct",
		},
		highlight_mode = "split_width",
		highlight_closest = true,
		highlight_on_jump = 300,
		link_folds_to_tree = false,
		link_tree_to_folds = true,
		manage_folds = false,
		layout = {
			max_width = { 40, 0.2 },
			width = nil,
			min_width = 10,
			win_opts = {},
			default_direction = "prefer_right",
			placement_editor_edge = true,
		},
		nerd_font = "auto",
		on_attach = nil,
		open_automatic = false,
		post_jump_cmd = "normal! zz",
		close_on_select = false,
		show_guides = true,
		guides = {
			mid_item = "├─",
			last_item = "└─",
			nested_top = "│ ",
			whitespace = "  ",
		},
		float = { border = "rounded", max_height = 100, min_height = 4 },
		treesitter = {
			update_delay = 300,
		},
		markdown = { update_delay = 300 },
	})
end
