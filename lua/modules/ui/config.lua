local config = {}

function config.material()
	require("material").setup({
		contrast = {
			sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
			floating_windows = true, -- Enable contrast for floating windows
			line_numbers = false, -- Enable contrast background for line numbers
			sign_column = false, -- Enable contrast background for the sign column
			cursor_line = false, -- Enable darker background for the cursor line
			non_current_windows = true, -- Enable darker background for non-current windows
			popup_menu = true, -- Enable lighter background for the popup menu
		},
		italics = {
			comments = true, -- Enable italic comments
			keywords = false, -- Enable italic keywords
			functions = true, -- Enable italic functions
			strings = true, -- Enable italic strings
			variables = true, -- Enable italic variables
		},
		contrast_filetypes = {
			"terminal", -- Darker terminal background
			"packer", -- Darker packer background
			"qf", -- Darker qf list background
			"undotree",
			"NvimTree",
			"dbui",
			"leaninfo",
			"calendar",
		},
		high_visibility = {
			lighter = true, -- Enable higher contrast text for lighter style
			darker = true, -- Enable higher contrast text for darker style
		},
		disable = {
			borders = false, -- Disable borders between verticaly split windows
			background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
			term_colors = false, -- Prevent the theme from setting terminal colors
			eob_lines = false, -- Hide the end-of-buffer lines
		},
		async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
		lualine_style = "default",
		custom_highlights = {}, -- Overwrite highlights with your own
	})
	vim.g.material_style = "palenight"
end

function config.edge()
	vim.cmd([[set background=dark]])
	vim.g.edge_style = "aura"
	vim.g.edge_enable_italic = 1
	vim.g.edge_disable_italic_comment = 1
	vim.g.edge_show_eob = 1
	vim.g.edge_better_performance = 1
	vim.g.edge_transparent_background = 1
end

function config.lualine()
	if not packer_plugins["nvim-navic"].loaded then
		vim.cmd([[packadd nvim-navic]])
	end
	local gps = require("nvim-navic")
	local function gps_content()
		if gps.is_available() then
			return gps.get_location()
		else
			return ""
		end
	end
	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local colors = {
		bg = "#202328",
		fg = "#bbc2cf",
		yellow = "#ECBE7B",
		cyan = "#008080",
		darkblue = "#081633",
		green = "#98be65",
		orange = "#FF8800",
		violet = "#a9a1e1",
		magenta = "#c678dd",
		blue = "#1793d1",
		red = "#ec5f67",
	}
	local conf = {
		options = {
			globalstatus = false,
			icons_enabled = true,
			theme = "dracula",
			disabled_filetypes = {},
			component_separators = "|",
			section_separators = { left = "", right = "" },
			hide_inactive_statusline = false,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				{ "branch", color = { fg = colors.yellow } },
				"diff",
				"diagnostics",
			},
			lualine_c = {
				{ "filename", color = { fg = colors.magenta } },
				"lsp_progress",
			},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "progress", "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		extensions = { "quickfix", "nvim-tree", "fugitive", "aerial" },
	}
	local function ins_left(component)
		table.insert(conf.sections.lualine_c, component)
	end

	local function ins_right(component)
		table.insert(conf.sections.lualine_x, component)
	end
	ins_left({
		-- filesize component
		"filesize",
		cond = conditions.buffer_not_empty,
	})

	ins_left({ gps_content, cond = gps.is_available })

	ins_right({
		"o:encoding", -- option component same as &encoding in viml
		fmt = string.upper, -- I'm not sure why it's upper case either ;)
		cond = conditions.hide_in_width,
		color = { fg = colors.violet, gui = "bold" },
	})

	ins_right({ "filetype", color = { fg = colors.blue } })

	ins_right({
		function()
			return ""
		end,
		color = { fg = colors.blue },
	})

	ins_right({
		function()
			return "ﬦ"
		end,
		color = { fg = colors.orange },
	})
	ins_right({
		-- Lsp server name .
		function()
			local msg = "No Active Lsp"
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return msg
			end
			msg = ""
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					msg = msg .. " " .. client.name
				end
			end
			return msg
		end,
		icon = " LSP:",
		color = { fg = colors.red, gui = "bold" },
	})

	require("lualine").setup(conf)
end

function config.nvim_tree()
	local tree_cb = require("nvim-tree.config").nvim_tree_callback
	require("nvim-tree").setup({
		auto_reload_on_write = true,
		disable_netrw = false,
		hijack_cursor = false,
		hijack_netrw = true,
		hijack_unnamed_buffer_when_opening = false,
		ignore_buffer_on_setup = false,
		open_on_setup = true,
		open_on_setup_file = false,
		open_on_tab = false,
		sort_by = "name",
		update_cwd = true,
		view = {
			width = 30,
			height = 30,
			hide_root_folder = false,
			side = "left",
			preserve_window_proportions = false,
			number = false,
			relativenumber = false,
			signcolumn = "yes",
			mappings = {
				custom_only = true,
				list = {
					{ key = { "<CR>", "o", "<2-LeftMouse>" }, cb = tree_cb("edit") },
					{ key = { "<2-RightMouse>", "<C-]>" }, cb = tree_cb("cd") },
					{ key = "<C-v>", cb = tree_cb("vsplit") },
					{ key = "<C-x>", cb = tree_cb("split") },
					{ key = "<C-t>", cb = tree_cb("tabnew") },
					{ key = "<", cb = tree_cb("prev_sibling") },
					{ key = ">", cb = tree_cb("next_sibling") },
					{ key = "P", cb = tree_cb("parent_node") },
					{ key = "<BS>", cb = tree_cb("close_node") },
					{ key = "<S-CR>", cb = tree_cb("close_node") },
					{ key = "<Tab>", cb = tree_cb("preview") },
					{ key = "K", cb = tree_cb("first_sibling") },
					{ key = "J", cb = tree_cb("last_sibling") },
					{ key = "I", cb = tree_cb("toggle_ignored") },
					{ key = "H", cb = tree_cb("toggle_dotfiles") },
					{ key = "R", cb = tree_cb("refresh") },
					{ key = "m", cb = tree_cb("create") },
					{ key = "d", cb = tree_cb("remove") },
					{ key = "a", cb = tree_cb("rename") },
					{ key = "<C-r>", cb = tree_cb("full_rename") },
					{ key = "x", cb = tree_cb("cut") },
					{ key = "yy", cb = tree_cb("copy") },
					{ key = "p", cb = tree_cb("paste") },
					{ key = "yn", cb = tree_cb("copy_name") },
					{ key = "yp", cb = tree_cb("copy_path") },
					{ key = "gy", cb = tree_cb("copy_absolute_path") },
					{ key = "[c", cb = tree_cb("prev_git_item") },
					{ key = "]c", cb = tree_cb("next_git_item") },
					{ key = "-", cb = tree_cb("dir_up") },
					{ key = "s", cb = tree_cb("system_open") },
					{ key = "q", cb = tree_cb("close") },
					{ key = "?", cb = tree_cb("toggle_help") },
				},
			},
		},
		renderer = {
			indent_markers = {
				enable = true,
				icons = {
					corner = "└ ",
					edge = "│ ",
					none = "  ",
				},
			},
			icons = {
				webdev_colors = true,
			},
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		update_focused_file = {
			enable = true,
			update_cwd = true,
			ignore_list = {},
		},
		ignore_ft_on_setup = {},
		system_open = {
			cmd = "",
			args = {},
		},
		diagnostics = {
			enable = true,
			show_on_dirs = false,
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		filters = {
			dotfiles = true,
			custom = {},
			exclude = {},
		},
		git = {
			enable = true,
			ignore = true,
			timeout = 400,
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
				restrict_above_cwd = false,
			},
			open_file = {
				quit_on_open = false,
				resize_window = true,
				window_picker = {
					enable = true,
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
						buftype = { "nofile", "terminal", "help" },
					},
				},
			},
		},
		trash = {
			cmd = "trash",
			require_confirm = true,
		},
	})
	vim.cmd(
		[[ autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif ]]
	)
end

function config.nvim_bufferline()
	require("bufferline").setup({
		options = {
			number = "none",
			modified_icon = "✥",
			buffer_close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 14,
			max_prefix_length = 13,
			tab_size = 20,
			show_buffer_close_icons = false,
			show_buffer_icons = true,
			show_tab_indicators = true,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			separator_style = "thick",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					padding = 1,
				},
				{
					filetype = "undotree",
					text = "Undo History",
					text_align = "left",
				},
				{
					filetype = "calendar",
					text = "Calendar",
					text_align = "right",
				},
				{
					filetype = "Outline",
					text = "Outline Window",
					text_align = "right",
				},
				{
					filetype = "earial",
					text = "Outline Window",
					text_align = "right",
				},
				{ filetype = "dbui", text = "Dbui", text_align = "left" },
				{ filetype = "leaninfo", text = "Leaninfo", text_align = "right" },
			},
		},
	})
end

function config.gitsigns()
	require("gitsigns").setup({
		signs = {
			add = {
				hl = "GitSignsAdd",
				text = "│",
				numhl = "GitSignsAddNr",
				linehl = "GitSignsAddLn",
			},
			change = {
				hl = "GitSignsChange",
				text = "│",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			delete = {
				hl = "GitSignsDelete",
				text = "_",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		watch_gitdir = { interval = 1000, follow_files = true },
		current_line_blame = true,
		current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		word_diff = false,
		diff_opts = { internal = true },
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, silent = true })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, silent = true })

			-- Actions
			map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
			map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
			map("n", "<leader>hS", gs.stage_buffer)
			map("n", "<leader>hu", gs.undo_stage_hunk)
			map("n", "<leader>hR", gs.reset_buffer)
			map("n", "<leader>hp", gs.preview_hunk)
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end)
			map("n", "<leader>tb", gs.toggle_current_line_blame)
			map("n", "<leader>hd", gs.diffthis)
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end)
			map("n", "<leader>td", gs.toggle_deleted)

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	})
end

function config.indent_blankline()
	vim.opt.termguicolors = true
	require("indent_blankline").setup({
		char = "│",
		show_first_indent_level = true,
		filetype_exclude = {
			"startify",
			"dotooagenda",
			"log",
			"fugitive",
			"gitcommit",
			"packer",
			"vimwiki",
			"markdown",
			"json",
			"txt",
			"vista",
			"help",
			"todoist",
			"NvimTree",
			"peekaboo",
			"git",
			"TelescopePrompt",
			"undotree",
			"flutterToolsOutline",
			"", -- for all buffers without a file type
		},
		buftype_exclude = { "terminal", "nofile" },
		show_trailing_blankline_indent = false,
		show_current_context = true,
		show_current_context_start = true,
		context_patterns = {
			"class",
			"function",
			"method",
			"block",
			"list_literal",
			"selector",
			"^if",
			"^table",
			"if_statement",
			"while",
			"for",
			"type",
			"var",
			"import",
		},
		space_char_blankline = " ",
	})
	vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
	vim.g.indentLine_concealcursor = ""
end

function config.web_icons()
	require("nvim-web-devicons").setup({
		override = {
			lean = {
				icon = "ﬦ",
				color = "#428850",
				cterm_color = "65",
				name = "lean",
			},
			v = {
				icon = "",
				color = "#42AA50",
				cterm_color = "65",
				name = "coq",
			},
			org = {
				icon = "",
				color = "#77A997",
				cterm_color = "65",
				name = "org",
			},
			norg = {
				icon = "",
				color = "#77A997",
				cterm_color = "65",
				name = "norg",
			},
			snippets = {
				icon = "",
				color = "#ec5f67",
				cterm_color = "65",
				name = "snippets",
			},
		},
		default = true,
	})
end

function config.alpha()
	local alpha = require("alpha")
	local startify = require("alpha.themes.startify")
	startify.section.top_buttons.val = {
		startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
		startify.button("f", "  Find file", ":Telescope find_files theme=dropdown<CR>"),
		startify.button("r", "  Recent file", ":Telescope frecency theme=dropdown<CR>"),
		startify.button("p", "  Find Project", ":Telescope projects theme=dropdown<CR>"),
	}
	alpha.setup(startify.config)
end

function config.popui()
	vim.ui.select = require("popui.ui-overrider")
	vim.ui.input = require("popui.input-overrider")
	vim.g.popui_border_style = "rounded"
end

function config.guihua()
	require("guihua.maps").setup({
		maps = {},
	})
end

return config
