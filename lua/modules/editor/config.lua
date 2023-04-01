local config = {}

function config.illuminate()
	require("illuminate").configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
		filetypes_denylist = {
			"alpha",
			"dashboard",
			"DoomInfo",
			"fugitive",
			"help",
			"norg",
			"NvimTree",
			"Outline",
			"packer",
			"toggleterm",
			"undotree",
			"leaninfo",
			"calendar",
		},
		under_cursor = false,
	})
end

function config.nvim_treesitter()
	vim.api.nvim_command("set foldmethod=expr")
	vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

	require("nvim-treesitter.configs").setup({
		sync_install = false,
		highlight = {
			enable = true,
			disable = { "lean" },
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
		context_commentstring = { enable = true },
		matchup = { enable = true },
		context = { enable = true, throttle = true },
		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]["] = "@function.outer",
					["]c"] = "@class.outer",
				},
				goto_next_end = {
					["]]"] = "@function.outer",
					["]C"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[c"] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[C"] = "@class.outer",
				},
			},
		},
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
			"latex",
			"javascript",
			"typescript",
			"r",
		},
	})
end

function config.matchup()
	vim.cmd([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]])
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

function config.dapui()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		dap = require("modules.ui.icons").get("dap"),
	}

	require("dapui").setup({
		icons = { expanded = icons.ui.ArrowOpen, collapsed = icons.ui.ArrowClosed, current_frame = icons.ui.Indicator },
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
						size = 0.25, -- Can be float or integer > 1
					},
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 40,
				position = "left",
			},
			{ elements = { "repl" }, size = 10, position = "bottom" },
		},
		-- Requires Nvim version >= 0.8
		controls = {
			enabled = true,
			-- Display controls in this session
			element = "repl",
			icons = {
				pause = icons.dap.Pause,
				play = icons.dap.Play,
				step_into = icons.dap.StepInto,
				step_over = icons.dap.StepOver,
				step_out = icons.dap.StepOut,
				step_back = icons.dap.StepBack,
				run_last = icons.dap.RunLast,
				terminate = icons.dap.Terminate,
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			mappings = { close = { "q", "<Esc>" } },
		},
		windows = { indent = 1 },
	})
end

function config.dap()
	local icons = { dap = require("modules.ui.icons").get("dap") }

	vim.api.nvim_command([[packadd nvim-dap-ui]])
	local dap = require("dap")
	local dapui = require("dapui")

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.after.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.after.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- We need to override nvim-dap's default highlight groups, AFTER requiring nvim-dap for catppuccin.
	vim.api.nvim_set_hl(0, "DapStopped", { fg = "#ABE9B3" })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = icons.dap.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = icons.dap.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = icons.dap.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = icons.dap.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = icons.dap.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp

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
		command = os.getenv("HOME") .. "/.pythonenv/virtualenvs/debugpy/bin/python",
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
	dap.adapters.go = function(callback)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				vim.notify(
					string.format('"dlv" exited with code: %d, please check your configs for correctness.', code),
					vim.log.levels.WARN,
					{ title = "[go] DAP Warning!" }
				)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end
	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{ type = "go", name = "Debug", request = "launch", program = "${file}" },
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		}, -- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
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
			ghciPrompt = "ghci>",
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
		\ 'iT'  :1,
		\ 'il'  :1,
		\ 'ix'  :1,
		\ }
		]])
end

function config.floaterm()
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
	local iron = require("iron.core")
	iron.setup({
		config = {
			scratch_repl = true,
			repl_definition = {
				sh = {
					command = { "zsh" },
				},
				python = {
					command = { "ipython" },
				},
				haskell = {
					command = { "ghci" },
				},
			},
			repl_open_cmd = require("iron.view").split.vertical.botright(70),
		},
		keymaps = {
			send_motion = "<space>is",
			visual_send = "<space>is",
			send_file = "<space>sf",
			send_line = "<space>sl",
			send_mark = "<space>sm",
			mark_motion = "<space>mc",
			mark_visual = "<space>mc",
			remove_mark = "<space>md",
			cr = "<space>s<cr>",
			interrupt = "<space>s<space>",
			exit = "<space>sq",
			clear = "<space>cl",
		},
		highlight = {
			italic = true,
		},
	})
end

function config.search_replace()
	require("search-replace").setup({
		default_replace_single_buffer_options = "gcI",
		default_replace_multi_buffer_options = "egcI",
	})
end

function config.neogen()
	require("neogen").setup({
		enabled = true,
		languages = {},
	})
end

function config.smartyank()
	require("smartyank").setup({
		highlight = {
			enabled = false, -- highlight yanked text
			higroup = "IncSearch", -- highlight group of yanked text
			timeout = 2000, -- timeout for clearing the highlight
		},
		clipboard = {
			enabled = true,
		},
		tmux = {
			enabled = true,
			-- remove `-w` to disable copy to host client's clipboard
			cmd = { "tmux", "set-buffer", "-w" },
		},
		osc52 = {
			enabled = true,
			escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
			ssh_only = true, -- false to OSC52 yank also in local sessions
			silent = false, -- true to disable the "n chars copied" echo
			echo_hl = "Directory", -- highlight group of the OSC52 echo message
		},
	})
end

function config.zen_mode()
	require("zen-mode").setup({
		window = {},
		plugins = {
			options = {
				enabled = true,
				ruler = true,
				showcmd = false,
			},
			twilight = { enabled = false },
			gitsigns = { enabled = true },
			tmux = { enabled = true },
			kitty = {
				enabled = true,
				font = "+1",
			},
		},
	})
end

return config
