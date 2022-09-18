local config = {}

function config.vim_cursorwod()
	vim.api.nvim_command("augroup user_plugin_cursorword")
	vim.api.nvim_command("autocmd!")
	vim.api.nvim_command("autocmd FileType NvimTree,dashboard let b:cursorword = 0")
	vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
	vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
	vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
	vim.api.nvim_command("augroup END")
end

function config.nvim_treesitter()
	vim.api.nvim_command("set foldmethod=expr")
	vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

	require("nvim-treesitter.configs").setup({
		sync_install = false,
		highlight = {
			enable = true,
			disable = { "latex", "lean" },
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
		context_commentstring = { enable = true },
		matchup = { enable = true },
		context = { enable = true, throttle = true },
		ensure_installed = {
			"c",
			"java",
			"python",
			"bash",
			"cpp",
			"css",
			"html",
			"haskell",
			"go",
			"lua",
			"norg",
			"php",
			"fish",
			"ruby",
			"vim",
			"yaml",
			"javascript",
			"typescript",
			"r",
		},
	})
end

function config.matchup()
	vim.cmd([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]])
end

function config.nvim_gps()
	require("nvim-navic").setup({
		icons = {
			File = " ",
			Module = " ",
			Namespace = " ",
			Package = " ",
			Class = " ",
			Method = " ",
			Property = " ",
			Field = " ",
			Constructor = " ",
			Enum = "練",
			Interface = "練",
			Function = " ",
			Variable = " ",
			Constant = " ",
			String = " ",
			Number = " ",
			Boolean = "◩ ",
			Array = " ",
			Object = " ",
			Key = " ",
			Null = "ﳠ ",
			EnumMember = " ",
			Struct = " ",
			Event = " ",
			Operator = " ",
			TypeParameter = " ",
		},
		highlight = false,
		separator = " > ",
		depth_limit = 0,
		depth_limit_indicator = "..",
	})
end

function config.autotag()
	require("nvim-ts-autotag").setup({
		filetypes = {
			"html",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"vue",
		},
	})
end

function config.nvim_colorizer()
	require("colorizer").setup()
end

function config.neoscroll()
	require("neoscroll").setup({
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		easing_function = nil, -- Default easing function
		pre_hook = nil, -- Function to run before the scrolling animation starts
		post_hook = nil, -- Function to run after the scrolling animation ends
	})
end

function config.toggleterm()
	require("toggleterm").setup({
		-- size can be a number or function which is passed the current terminal
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.40
			end
		end,
		open_mapping = [[<c-\>]],
		hide_numbers = true, -- hide the number column in toggleterm buffers
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true, -- close the terminal window when the process exits
		shell = vim.o.shell, -- change the default shell
	})
end

function config.dap()
	local dap = require("dap")
	local dapui = require("dapui")
	local dap_breakpoint = {
		error = {
			text = "🛑",
			texthl = "LspDiagnosticsSignError",
			linehl = "",
			numhl = "",
		},
		rejected = {
			text = "",
			texthl = "LspDiagnosticsSignHint",
			linehl = "",
			numhl = "",
		},
		stopped = {
			text = "⭐️",
			texthl = "LspDiagnosticsSignInformation",
			linehl = "DiagnosticUnderlineInfo",
			numhl = "LspDiagnosticsSignInformation",
		},
	}
	vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
	vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
	vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

	require("dapui").setup({
		icons = { expanded = "▾", collapsed = "▸" },
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
		},
		layouts = {
			{
				elements = {
					-- Provide as ID strings or tables with "id" and "size" keys
					{
						id = "scopes",
						size = 0.35, -- Can be float or integer > 1
					},
					{ id = "stacks", size = 0.35 },
					{ id = "watches", size = 0.15 },
					{ id = "breakpoints", size = 0.15 },
				},
				size = 40,
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 10,
				position = "bottom",
			},
		},
		render = {
			max_type_length = 15, -- Can be integer or nil.
		},
		floating = {
			max_height = nil,
			max_width = nil,
			border = "single",
			mappings = { close = { "q", "<Esc>" } },
		},
		windows = { indent = 1 },
	})
	local debug_open = function()
		dapui.open()
	end
	local debug_close = function()
		dap.repl.close()
		dapui.close()
	end

	dap.listeners.after.event_initialized["dapui_config"] = function()
		debug_open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		debug_close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		debug_close()
	end
	dap.listeners.before.disconnect["dapui_config"] = function()
		debug_close()
	end
	dap.defaults.fallback.terminal_win_cmd = "30vsplit new" -- this will be overrided by dapui
	dap.set_log_level("DEBUG")

	dap.adapters.lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	}

	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},

			runInTerminal = false,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	dap.adapters.python = {
		type = "executable",
		command = os.getenv("HOME") .. "/.virtualenvs/debugpy/bin/python",
		args = { "-m", "debugpy.adapter" },
	}
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}
	dap.adapters.haskell = {
		type = "executable",
		command = "haskell-debug-adapter",
		args = { "--hackage-version=0.0.33.0" },
	}
	dap.configurations.haskell = {
		{
			type = "haskell",
			request = "launch",
			name = "Debug",
			workspace = "${workspaceFolder}",
			startup = "${file}",
			stopOnEntry = true,
			logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
			logLevel = "WARNING",
			ghciEnv = vim.empty_dict(),
			ghciPrompt = "λ> ",
			-- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
			ghciInitialPrompt = "λ>>",
			ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
		},
	}
end

function config.specs()
	require("specs").setup({
		show_jumps = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 10, -- time increments used for fade/resize effects
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
			width = 10,
			winhl = "PMenu",
			fader = require("specs").pulse_fader,
			resizer = require("specs").shrink_resizer,
		},
		ignore_filetypes = {},
		ignore_buftypes = { nofile = true },
	})
end

function config.expand_region()
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
		\ 'i,'  :1,
		\ 'il'  :1
		\ }
		]])
end

function config.floaterm()
	vim.g.floaterm_width = 0.7
	vim.g.floaterm_height = 0.7
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
end

function config.add_header()
	vim.g.header_auto_add_header = 0
	vim.g.header_alignment = 1
	vim.g.header_field_filename_path = 1
	vim.g.header_field_author = "allen"
	vim.g.header_field_author_email = "mzm191891@163.com"
	vim.g.header_field_timestamp_format = "%Y-%m-%d"
end

function config.tabout()
	require("tabout").setup({
		tabkey = "<A-j>", -- key to trigger tabout, set to an empty string to disable
		backwards_tabkey = "<A-k>", -- key to trigger backwards tabout, set to an empty string to disable
		act_as_tab = false, -- shift content if tab out is not possible
		act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
		enable_backwards = true, -- well ...
		completion = false, -- if the tabkey is used in a completion pum
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
	})
end

function config.multi()
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

function config.iron()
	local iron = require("iron")
	iron.core.add_repl_definitions({
		iron.core.set_config({
			preferred = { python = "ipython", haskell = "ghci" },
		}),
	})
	vim.g.iron_map_default = 0
	vim.g.iron_map_extended = 0
end

function config.far_vim()
	vim.cmd([[let g:far#enable_undo=1]])
end

function config.neogen()
	require("neogen").setup({
		enabled = true,
		languages = {},
	})
end

return config
