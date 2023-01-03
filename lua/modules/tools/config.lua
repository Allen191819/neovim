local config = {}
function config.telescope()
	if not packer_plugins["sqlite.lua"].loaded then
		vim.cmd([[packadd sqlite.lua]])
	end
	if not packer_plugins["telescope-frecency.nvim"].loaded then
		vim.cmd([[packadd telescope-frecency.nvim]])
	end
	if not packer_plugins["project.nvim"].loaded then
		vim.cmd([[packadd project.nvim]])
	end
	if not packer_plugins["aerial.nvim"].loaded then
		vim.cmd([[packadd aerial.nvim]])
	end
	if not packer_plugins["telescope-live-grep-raw.nvim"].loaded then
		vim.cmd([[packadd telescope-live-grep-raw.nvim]])
	end
	if not packer_plugins["telescope-zoxide"].loaded then
		vim.cmd([[packadd telescope-zoxide]])
	end
	if not packer_plugins["telescope-ultisnips.nvim"].loaded then
		vim.cmd([[packadd telescope-ultisnips.nvim]])
	end
	require("project_nvim").setup({
		manual_mode = false,
		detection_methods = { "lsp", "pattern" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
		ignore_lsp = { "efm" },
		exclude_dirs = {},
		show_hidden = false,
		silent_chdir = true,
		scope_chdir = "global",
		datapath = vim.fn.stdpath("data"),
	})
	require("telescope").setup({
		defaults = {
			prompt_prefix = "🔭 ",
			selection_caret = " ",
			layout_config = {
				horizontal = { prompt_position = "top", results_width = 0.6 },
				vertical = { mirror = false },
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			file_ignore_patterns = {},
			path_display = { "absolute" },
			winblend = 0,
			border = {},
			borderchars = {
				"─",
				"│",
				"─",
				"│",
				"╭",
				"╮",
				"╯",
				"╰",
			},
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" },
		},
		extensions = {
			frecency = {
				show_scores = true,
				show_unindexed = true,
				ignore_patterns = { "*.git/*", "*/tmp/*" },
			},
		},
	})
	require("telescope").load_extension("projects")
	require("telescope").load_extension("frecency")
	require("telescope").load_extension("aerial")
	require("telescope").load_extension("live_grep_args")
	require("telescope").load_extension("zoxide")
	require("telescope").load_extension("ultisnips")
	require("telescope").load_extension("notify")
end

function config.trouble()
	require("trouble").setup({
		position = "bottom", -- position of the list can be: bottom, top, left, right
		height = 10, -- height of the trouble list when position is top or bottom
		width = 50, -- width of the list when position is left or right
		icons = true, -- use devicons for filenames
		mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
		fold_open = "", -- icon used for open folds
		fold_closed = "", -- icon used for closed folds
		action_keys = {
			-- key mappings for actions in the trouble list
			-- map to {} to remove a mapping, for example:
			-- close = {},
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
			open_split = { "<c-x>" }, -- open buffer in new split
			open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
			open_tab = { "<c-t>" }, -- open buffer in new tab
			jump_close = { "o" }, -- jump to the diagnostic and close the list
			toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
			toggle_preview = "P", -- toggle auto_preview
			hover = "K", -- opens a small popup with the full multiline message
			preview = "p", -- preview the diagnostic location
			close_folds = { "zM", "zm" }, -- close all folds
			open_folds = { "zR", "zr" }, -- open all folds
			toggle_fold = { "zA", "za" }, -- toggle fold of current file
			previous = "k", -- preview item
			next = "j", -- next item
		},
		indent_lines = true, -- add an indent guide below the fold icons
		auto_open = false, -- automatically open the list when you have diagnostics
		auto_close = true, -- automatically close the list when you have no diagnostics
		auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
		auto_fold = false, -- automatically fold a file trouble list at creation
		auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
		signs = {
			-- icons / text used for a diagnostic
			error = "",
			warning = "",
			hint = "",
			information = "",
			other = "﫠",
		},
		use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
	})
end

function config.sniprun()
	require("sniprun").setup({
		selected_interpreters = {}, -- " use those instead of the default for the current filetype
		repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
		repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
		interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
		-- " you can combo different display modes as desired
		display = {
			"Classic", -- "display results in the command-line  area
			"VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
			"VirtualTextErr", -- "display error results as virtual text
			"TempFloatingWindow", -- "display results in a floating window
			-- "LongTempFloatingWindow" -- "same as above, but only long results. To use with VirtualText__
			-- "Terminal"                 -- "display results in a vertical split
		},
		-- " miscellaneous compatibility/adjustement settings
		inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
		-- " to workaround sniprun not being able to display anything

		borders = "shadow", -- " display borders around floating windows
		-- " possible values are 'none', 'single', 'double', or 'shadow'
	})
end

function config.undotree()
	vim.g.undotree_WindowLayout = 4
	vim.g.undotree_SetFocusWhenToggle = 1
	vim.cmd([[
	if has("persistent_undo")
		let target_path = expand('~/.undodir')
		if !isdirectory(target_path)
			call mkdir(target_path, "p", 0700)
			endif
			let &undodir=target_path
			set undofile
			endif
			]])
end

function config.aerial()
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

function config.suda()
	vim.g.suda_smart_edit = 1
end

function config.bookmarks()
	vim.cmd([[
	highlight BookmarkSign ctermbg=NONE ctermfg=160
	highlight BookmarkLine ctermbg=194 ctermfg=NONE
	]])
	vim.g.bookmark_sign = "🔖"
	vim.g.bookmark_no_default_key_mappings = 1
	vim.g.bookmark_highlight_lines = 1
end

function config.notify()
	local icons = {
		diagnostics = require("modules.ui.icons").get("diagnostics"),
		ui = require("modules.ui.icons").get("ui"),
	}
	vim.notify = require("notify")
	local notify = require("notify")
	local user_config = {
		background_colour = "Normal",
		fps = 30,
		icons = {
			ERROR = icons.diagnostics.Error,
			WARN = icons.diagnostics.Warning,
			INFO = icons.diagnostics.Information,
			DEBUG = icons.ui.Bug,
			TRACE = icons.ui.Pencil,
		},
		level = "info",
		minimum_width = 50,
		render = "default",
		stages = "fade_in_slide_out",
		timeout = 2000,
	}
	notify.setup(user_config)
end

function config.wilder()
	local wilder = require("wilder")
	local icons = { ui = require("modules.ui.icons").get("ui") }

	wilder.setup({ modes = { ":", "/", "?" } })
	wilder.set_option("use_python_remote_plugin", 0)
	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }),
			wilder.vim_search_pipeline(),
			{
				wilder.check(function(_, x)
					return x == ""
				end),
				wilder.history(),
				wilder.result({
					draw = {
						function(_, x)
							return icons.ui.Calendar .. " " .. x
						end,
					},
				}),
			}
		),
	})

	local string_fg = vim.api.nvim_get_hl_by_name("String", true).foreground
	local match_hl = string_fg ~= nil and string.format("#%06x", string_fg) or "#ABE9B3"

	local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		border = "rounded",
		highlights = {
			border = "Title", -- highlight to use for the border
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 0 }, { a = 0 }, { foreground = match_hl } }),
		},
		empty_message = wilder.popupmenu_empty_message_with_spinner(),
		highlighter = wilder.lua_fzy_highlighter(),
		left = {
			" ",
			wilder.popupmenu_devicons(),
			wilder.popupmenu_buffer_flags({
				flags = " a + ",
				icons = { ["+"] = icons.ui.Pencil, a = icons.ui.Indicator, h = icons.ui.File },
			}),
		},
		right = {
			" ",
			wilder.popupmenu_scrollbar(),
		},
	}))
	local wildmenu_renderer = wilder.wildmenu_renderer({
		highlighter = wilder.lua_fzy_highlighter(),
		apply_incsearch_fix = true,
	})
	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			[":"] = popupmenu_renderer,
			["/"] = wildmenu_renderer,
			substitute = wildmenu_renderer,
		})
	)
end


function config.which_key()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		misc = require("modules.ui.icons").get("misc"),
	}

	require("which-key").setup({
		plugins = {
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},

		icons = {
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			group = icons.misc.Add,
		},

		window = {
			border = "none",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 1, 1, 1, 1 },
			winblend = 0,
		},
	})
end

return config
