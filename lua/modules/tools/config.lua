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

	require("project_nvim").setup()
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

function config.wilder()
	vim.cmd([[
	call wilder#setup({'modes': [':', '/', '?']})
	call wilder#set_option('use_python_remote_plugin', 0)

	call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])

	call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer({'highlighter': wilder#lua_fzy_highlighter(), 'left': [wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()]}), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))
	]])
end

function config.dadbod()
	vim.g.db_ui_show_database_icon = 1
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_save_localtion = "/home/allen/.local/shar/nvim/dadbod"
	vim.g.db_ui_auto_execute_table_helpers = 1
	vim.g.dbs = { Mydb = "mysql://root:123456@localhost/mydb" }
	vim.g.db_ui_table_helpers = {
		mysql = { List = 'select * from "{table}" order by id asc' },
	}
	vim.g.db_ui_icons = {
		expanded = {
			db = "▾ ",
			buffers = "▾ ",
			saved_queries = "▾ ",
			schemas = "▾ ",
			schema = "▾ פּ",
			tables = "▾ 藺",
			table = "▾ ",
		},
		collapsed = {
			db = "▸ ",
			buffers = "▸ ",
			saved_queries = "▸ ",
			schemas = "▸ ",
			schema = "▸ פּ",
			tables = "▸ 藺",
			table = "▸ ",
		},
		saved_query = "",
		new_query = "璘",
		tables = "離",
		buffers = "﬘",
		add_connection = "",
		connection_ok = "✓",
		connection_error = "✕",
	}
end

function config.quickrun()
	vim.cmd([[
	let b:quickrun_config = {'outputter/buffer/into': 1,"outputter/opener":"new"}
	]])
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
	vim.notify = require("notify")
	local notify = require("notify")
	local user_config = {
		background_colour = "#000000",
		fps = 30,
		icons = {
			DEBUG = "",
			ERROR = "",
			INFO = "",
			TRACE = "✎",
			WARN = "",
		},
		level = "info",
		minimum_width = 50,
		render = "default",
		stages = "fade_in_slide_out",
		timeout = 3000,
	}
	notify.setup(user_config)
end

function config.translate()
	require("translate").setup({
		default = {
			output = "floating",
		},
	})
end

function config.venn()
	function _G.Toggle_venn()
		local venn_enabled = vim.inspect(vim.b.venn_enabled)
		if venn_enabled == "nil" then
			vim.b.venn_enabled = true
			vim.cmd([[setlocal ve=all]])
			-- draw a line on HJKL keystokes
			vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
			-- draw a box by pressing "f" with visual selection
			vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
		else
			vim.cmd([[setlocal ve=]])
			vim.cmd([[mapclear <buffer>]])
			vim.b.venn_enabled = nil
		end
	end
	-- toggle keymappings for venn using <leader>v
	vim.api.nvim_set_keymap("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true })
end

return config
