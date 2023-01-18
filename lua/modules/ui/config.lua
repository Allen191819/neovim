local config = {}

function config.tokyonight()
	require("tokyonight").setup({
		style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		light_style = "day", -- The theme is used when the background is set to light
		transparent = false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			sidebars = "dark", -- style for sidebars, see below
			floats = "dark", -- style for floating windows
		},
		sidebars = {
			"qf",
			"help",
			"undotree",
			"NvimTree",
			"dbui",
			"leaninfo",
			"calendar",
		}, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = true,
		on_colors = function(colors) end,
		on_highlights = function(highlights, colors) end,
	})
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
			theme = "tokyonight",
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

	ins_right({
		"o:encoding", -- option component same as &encoding in viml
		fmt = string.upper, -- I'm not sure why it's upper case either ;)
		cond = conditions.hide_in_width,
		color = { fg = colors.violet, gui = "bold" },
	})

	ins_right({ "filetype", color = { fg = colors.blue } })

	-- ins_right({
	-- 	function()
	-- 		return ""
	-- 	end,
	-- 	color = { fg = colors.blue },
	-- })

	ins_right({
		function()
			return "ﬦ"
		end,
		color = { fg = colors.orange },
	})
	ins_right({
		-- Lsp server name .
		function()
			local msg = "No Lsp"
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
			msg = string.gsub(msg, "^%s*(.-)%s*$", "%1")
			return msg
		end,
		icon = " LSP:",
		color = { fg = colors.red },
	})

	require("lualine").setup(conf)
end

function config.nvim_tree()
	local icons = {
		diagnostics = require("modules.ui.icons").get("diagnostics"),
		documents = require("modules.ui.icons").get("documents"),
		git = require("modules.ui.icons").get("git"),
		ui = require("modules.ui.icons").get("ui"),
	}
	require("nvim-tree").setup({
		create_in_closed_folder = false,
		respect_buf_cwd = false,
		auto_reload_on_write = true,
		disable_netrw = false,
		hijack_cursor = true,
		hijack_netrw = true,
		hijack_unnamed_buffer_when_opening = false,
		ignore_buffer_on_setup = false,
		open_on_setup = false,
		open_on_setup_file = false,
		open_on_tab = false,
		sort_by = "name",
		sync_root_with_cwd = true,
		view = {
			adaptive_size = false,
			centralize_selection = false,
			width = 30,
			side = "left",
			preserve_window_proportions = false,
			number = false,
			relativenumber = false,
			signcolumn = "yes",
			hide_root_folder = false,
			float = {
				enable = false,
				open_win_config = {
					relative = "editor",
					border = "rounded",
					width = 30,
					height = 30,
					row = 1,
					col = 1,
				},
			},
		},
		renderer = {
			add_trailing = false,
			group_empty = true,
			highlight_git = false,
			full_name = false,
			highlight_opened_files = "none",
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
			symlink_destination = true,
			indent_markers = {
				enable = true,
				icons = {
					corner = "└ ",
					edge = "│ ",
					item = "│ ",
					none = "  ",
				},
			},
			root_folder_label = ":.:s?.*?/..?",
			icons = {
				webdev_colors = true,
				git_placement = "before",
				show = {
					file = true,
					folder = true,
					folder_arrow = false,
					git = true,
				},
				padding = " ",
				symlink_arrow = "  ",
				glyphs = {
					default = icons.documents.Default, --
					symlink = icons.documents.Symlink, --
					bookmark = icons.ui.Bookmark,
					git = {
						unstaged = icons.git.Mod_alt,
						staged = icons.git.Add, --
						unmerged = icons.git.Unmerged,
						renamed = icons.git.Rename, --
						untracked = icons.git.Untracked, -- "ﲉ"
						deleted = icons.git.Remove, --
						ignored = icons.git.Ignore, --◌
					},
					folder = {
						-- arrow_open = "",
						-- arrow_closed = "",
						arrow_open = "",
						arrow_closed = "",
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.SymlinkFolder,
						symlink_open = icons.ui.FolderOpen,
					},
				},
			},
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		update_focused_file = {
			enable = true,
			update_root = true,
			ignore_list = {},
		},
		ignore_ft_on_setup = {},
		filters = {
			dotfiles = false,
			custom = { ".DS_Store" },
			exclude = {},
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
			},
			open_file = {
				quit_on_open = false,
				resize_window = false,
				window_picker = {
					enable = true,
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
						buftype = { "nofile", "terminal", "help" },
					},
				},
			},
			remove_file = {
				close_window = true,
			},
		},
		diagnostics = {
			enable = false,
			show_on_dirs = false,
			debounce_delay = 50,
			icons = {
				hint = icons.diagnostics.Hint_alt,
				info = icons.diagnostics.Information_alt,
				warning = icons.diagnostics.Warning_alt,
				error = icons.diagnostics.Error_alt,
			},
		},
		filesystem_watchers = {
			enable = true,
			debounce_delay = 50,
		},
		git = {
			enable = true,
			ignore = true,
			show_on_dirs = true,
			timeout = 400,
		},
		trash = {
			cmd = "gio trash",
			require_confirm = true,
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = true,
		},
		log = {
			enable = false,
			truncate = false,
			types = {
				all = false,
				config = false,
				copy_paste = false,
				dev = false,
				diagnostics = false,
				git = false,
				profile = false,
				watcher = false,
			},
		},
	})
end

function config.nvim_bufferline()
	local icons = { ui = require("modules.ui.icons").get("ui") }
	require("bufferline").setup({
		options = {
			number = nil,
			modified_icon = icons.ui.Modified,
			buffer_close_icon = icons.ui.Close,
			left_trunc_marker = icons.ui.Left,
			right_trunc_marker = icons.ui.Right,
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
				{
					filetype = "fugitive",
					text = "Fugitive",
					text_align = "center",
				},
			},
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
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
	vim.opt.list = false
	vim.opt.listchars:append "tab:│·"
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
		startify.button("r", "  File frecency", ":Telescope frecency theme=dropdown<CR>"),
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

function config.neodim()
	local normal_background = vim.api.nvim_get_hl_by_name("Normal", true).background
	local blend_color = normal_background ~= nil and string.format("#%06x", normal_background) or "#000000"

	require("neodim").setup({
		alpha = 0.45,
		blend_color = blend_color,
		update_in_insert = {
			enable = true,
			delay = 100,
		},
		hide = {
			virtual_text = true,
			signs = false,
			underline = false,
		},
	})
end

function config.fidget()
	require("fidget").setup({})
end
return config
