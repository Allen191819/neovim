local config = {}

function config.rust_tools()
	local function custom_attach(client)
		require("lsp_signature").on_attach({
			bind = true,
			use_lspsaga = false,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hi_parameter = "Search",
			handler_opts = { "double" },
		})

		if client.resolved_capabilities.document_formatting then
			vim.cmd([[augroup Format]])
			vim.cmd([[autocmd! * <buffer>]])
			vim.cmd([[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]])
			vim.cmd([[augroup END]])
		end
	end

	local opts = {
		tools = {
			-- rust-tools options
			-- Automatically set inlay hints (type hints)
			autoSetHints = true,
			-- Whether to show hover actions inside the hover window
			-- This overrides the default hover handler
			hover_with_actions = true,
			runnables = {
				-- whether to use telescope for selection menu or not
				use_telescope = true,

				-- rest of the opts are forwarded to telescope
			},
			debuggables = {
				-- whether to use telescope for selection menu or not
				use_telescope = true,

				-- rest of the opts are forwarded to telescope
			},
			-- These apply to the default RustSetInlayHints command
			inlay_hints = {
				-- Only show inlay hints for the current line
				only_current_line = false,
				-- Event which triggers a refersh of the inlay hints.
				-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
				-- not that this may cause  higher CPU usage.
				-- This option is only respected when only_current_line and
				-- autoSetHints both are true.
				only_current_line_autocmd = "CursorHold",
				-- wheter to show parameter hints with the inlay hints or not
				show_parameter_hints = true,
				-- prefix for parameter hints
				parameter_hints_prefix = "<- ",
				-- prefix for all the other hints (type, chaining)
				other_hints_prefix = " » ",
				-- whether to align to the length of the longest line in the file
				max_len_align = false,
				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,
				-- whether to align to the extreme right or not
				right_align = false,
				-- padding from the right if right_align is true
				right_align_padding = 7,
			},
			hover_actions = {
				-- the border that is used for the hover window
				-- see vim.api.nvim_open_win()
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				-- whether the hover action window gets automatically focused
				auto_focus = false,
			},
		},
		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
		server = {
			standalone = false,
			on_attach = function(client)
				client.resolved_capabilities.document_formatting = false
				custom_attach(client)
			end,
		}, -- rust-analyer options
	}
	require("rust-tools").setup(opts)
end

function config.lang_go()
	local path = require("nvim-lsp-installer.path")
	local install_root_dir = path.concat({ vim.fn.stdpath("data"), "lsp_servers" })

	require("go").setup({
		go = "go", -- go command, can be go[default] or go1.18beta1
		goimport = "gopls", -- goimport command, can be gopls[default] or goimport
		fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
		gofmt = "gofumpt", -- gofmt cmd,
		gopls_cmd = { install_root_dir .. "/go/gopls" },
		max_line_len = 120, -- max line length in goline format
		tag_transform = false, -- tag_transfer  check gomodifytags for details
		comment_placeholder = "ﳑ ", -- comment_placeholder your cool placeholder e.g. ﳑ       
		icons = { breakpoint = "🧘", currentpos = "🏃" },
		verbose = false, -- output loginf in messages
		lsp_cfg = true, -- true: use non-default gopls setup specified in go/lsp.lua
		lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
		lsp_codelens = true, -- set to false to disable codelens, true by default
		lsp_diag_hdlr = true, -- hook lsp diag handler
		lsp_document_formatting = true,
		gopls_remote_auto = true, -- add -remote=auto to gopls
		dap_debug = true, -- set to false to disable dap
		dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
		dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
		dap_debug_vt = false, -- set to true to enable dap virtual text
		build_tags = "tag1,tag2", -- set default build tags
		textobjects = false, -- enable default text jobects through treesittter-text-objects
		test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
		run_in_floaterm = true, -- set to true to run in float window.
		filstruct = "gopls",
	})
end

function config.makrkdown_preview()
	vim.g.mkdp_auto_start = 0
	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_refresh_slow = 0
	vim.g.mkdp_command_for_global = 0
	vim.g.mkdp_browser = "surf"
	vim.g.mkdp_page_title = "「${name}」"
	vim.g.mkdp_filetypes = { "markdown" }
	vim.g.mkdp_preview_options = {
		hide_yaml_meta = 1,
		disable_filename = 1,
		theme = "light",
	}
	vim.g.mkdp_markdown_css = "/home/allen/.config/nvim/color/markdown.css"
	vim.g.spelllang = "nl,en-gb"
	vim.g.vmt_auto_update_on_save = 1
	--vim.cmd([[
	--autocmd BufRead,BufNewFile *.md setlocal spell
	--]])
end

function config.clipboard_image()
	local filename = vim.fn.expand("%:t:r")
	require("clipboard-image").setup({
		default = {
			img_dir = "img/" .. filename,
			img_dir_txt = "img/" .. filename,
			img_name = function()
				vim.fn.inputsave()
				local name = vim.fn.input("Name: ")
				vim.fn.inputrestore()
				if name == nil or name == "" then
					return os.date("%y-%m-%d-%H-%M-%S")
				end
				return name
			end,
			affix = "%s",
		},
		markdown = { affix = "![](%s)" },
		tex = { affix = "{%s}" },
	})
end

function config.latex()
	vim.g.vimtex_view_method = "zathura"
	vim.g.vimtex_quickfix_mode = 0
	vim.g.tex_flavor = "latex"
	vim.g.conceallevel = 2
	vim.g.tex_conceal = "abdmg"
	vim.g.vimtex_compliler_progname = "nvr"
	vim.g.vimtex_mappings_enabled = 0
	vim.g.vimtex_text_obj_enabled = 0
	vim.g.vimtex_motion_enabled = 0
	vim.g.vimtex_syntax_conceal = {
		accents = 1,
		cites = 1,
		fancy = 1,
		greek = 1,
		math_bounds = 1,
		math_delimiters = 1,
		math_fracs = 1,
		math_super_sub = 1,
		math_symbols = 1,
		sections = 1,
		styles = 1,
	}
	vim.cmd([[
	autocmd BufRead,BufNewFile *.tex setlocal spell
	]])
end
function config.neorg()
	if not packer_plugins["nvim-cmp"].loaded then
		vim.cmd([[packadd nvim-cmp]])
	end
	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.norg.dirman"] = {
				config = {
					workspaces = {
						work = "~/neorg/work",
						home = "~/neorg/home",
					},
				},
			},
			["core.norg.concealer"] = { config = { icon_preset = "diamond" } },
			["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
		},
	})
	local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
	parser_configs.norg_table = {
		install_info = {
			url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
			files = { "src/parser.c" },
			branch = "main",
		},
	}
	parser_configs.norg_meta = {
		install_info = {
			url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
			files = { "src/parser.c" },
			branch = "main",
		},
	}
end
return config
