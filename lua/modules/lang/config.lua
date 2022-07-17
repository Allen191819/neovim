local config = {}

function config.rust_tools()
	local function lsp_highlight_document(client)
		if client.server_capabilities.document_highlight then
			vim.api.nvim_exec(
				[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
				false
			)
		end
	end

	local function custom_attach(client)
		vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
		vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = "always",
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})
		require("lsp_signature").on_attach({
			bind = true,
			use_lspsaga = false,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hi_parameter = "Search",
			handler_opts = {
				border = "rounded",
			},
		})
		if client.server_capabilities.document_formatting then
			vim.cmd([[augroup Format]])
			vim.cmd([[autocmd! * <buffer>]])
			vim.cmd([[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]])
			vim.cmd([[augroup END]])
		end
		lsp_highlight_document(client)
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end

	local extension_path = vim.env.HOME .. "/.local/share/nvim/rust-debug/codelldb-x86_64-linux/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
	local opts = {
		tools = {
			autoSetHints = true,
			hover_with_actions = true,
			executor = require("rust-tools/executors").termopen,
			inlay_hints = {
				only_current_line = false,
				only_current_line_autocmd = "CursorHold",
				show_parameter_hints = true,
				parameter_hints_prefix = "  ",
				other_hints_prefix = "  » ",
				max_len_align = false,
				max_len_align_padding = 1,
				right_align = false,
				right_align_padding = 7,
			},
			hover_actions = {
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
				auto_focus = false,
			},
		},
		server = {
			standalone = false,
			on_attach = function(client)
				client.server_capabilities.document_formatting = true
				custom_attach(client)
			end,
		}, -- rust-analyer options
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
	require("rust-tools").setup(opts)
end

function config.lang_go()
	local function lsp_highlight_document(client)
		if client.server_capabilities.document_highlight then
			vim.api.nvim_exec(
				[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
				false
			)
		end
	end

	local function custom_attach(client)
		vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
		vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = "always",
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})
		require("lsp_signature").on_attach({
			bind = true,
			use_lspsaga = false,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hi_parameter = "Search",
			handler_opts = {
				border = "rounded",
			},
		})
		if client.server_capabilities.document_formatting then
			vim.cmd([[augroup Format]])
			vim.cmd([[autocmd! * <buffer>]])
			vim.cmd([[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]])
			vim.cmd([[augroup END]])
		end
		lsp_highlight_document(client)
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end

	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	require("go").setup({
		go = "go", -- go command, can be go[default] or go1.18beta1
		goimport = "goimport", -- goimport command, can be gopls[default] or goimport
		gopls_cmd = { "gopls" },
		max_line_len = 120, -- max line length in goline format
		tag_transform = true, -- tag_transfer  check gomodifytags for details
		fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
		gofmt = "gofumpt", --gofmt cmd,
		comment_placeholder = "",
		icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
		verbose = false, -- output loginf in messages
		lsp_cfg = {
			capabilities = capabilities,
			on_attach = function(client)
				client.server_capabilities.document_formatting = true
				custom_attach(client)
			end,
		},
		lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
		lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
		lsp_codelens = false, -- set to false to disable codelens, true by default, you can use a function
		lsp_diag_hdlr = true, -- hook lsp diag handler
		lsp_diag_virtual_text = false,
		lsp_diag_signs = true,
		lsp_diag_update_in_insert = false,
		lsp_document_formatting = true,
		gopls_remote_auto = true, -- add -remote=auto to gopls
		dap_debug = true, -- set to false to disable dap
		dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
		dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
		dap_debug_vt = false, -- set to true to enable dap virtual text
		build_tags = "tag1,tag2", -- set default build tags
		textobjects = false, -- enable default text jobects through treesittter-text-objects
		test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`}
		verbose_tests = true, -- set to add verbose flag to tests
		run_in_floaterm = true, -- set to true to run in float window. :GoTermClose closes the floatterm
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
	vim.g.mkdp_theme = "dark"
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

function config.lean()
	vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
	vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])
	local function custom_attach_lean(client)
		require("lsp_signature").on_attach({
			bind = true,
			use_lspsaga = false,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hi_parameter = "Search",
			handler_opts = { "double" },
		})

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			signs = false,
			underline = false,
			virtual_text = { spacing = 15, prefix = "" },
			update_in_insert = true,
		})

		if client.server_capabilities.document_formatting then
			vim.cmd([[augroup Format]])
			vim.cmd([[autocmd! * <buffer>]])
			vim.cmd([[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]])
			vim.cmd([[augroup END]])
		end
	end
	require("lean").setup({
		abbreviations = { builtin = true, extra = { wknight = "♘" } },
		lsp = { on_attach = custom_attach_lean },
		lsp3 = { on_attach = custom_attach_lean },
		mappings = true,
		infoview = {
			autoopen = true,
			width = 40,
			height = 20,
			indicators = "always",
		},
		progress_bars = { enable = true, priority = 10 },
		stderr = { enable = true },
	})
end

return config
