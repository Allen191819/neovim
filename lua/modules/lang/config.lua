local config = {}


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local function custom_attach(client)
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
end

function config.rust_tools()
	vim.api.nvim_command([[packadd nvim-lspconfig]])
	vim.api.nvim_command([[packadd lsp_signature.nvim]])
	local opts = {
		tools = {
			autoSetHints = true,
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
			settings = {
				['rust-analyzer'] = {
					cargo = {
						target = "x86_64-unknown-none",
					},
					check = {
						allTargets = false,
						extraArgs = { "--target", "x86_64-unknown-none" },
					}
				}
			}
		}, -- rust-analyer options
		on_initialized = function(client)
			custom_attach(client)
		end,
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	}
	require("rust-tools").setup(opts)
	vim.g.rust_clip_command = "xclip -selection clipboard"
end

function config.lang_go()
	vim.g.go_doc_keywordprg_enabled = 0
	vim.g.go_def_mapping_enabled = 0
	vim.g.go_code_completion_enabled = 0
end

function config.markdown_preview()
	vim.g.mkdp_theme = 'dark'
	vim.g.mkdp_port = '2233'
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

function config.norg()
	if not packer_plugins["nvim-cmp"].loaded then
		vim.cmd([[packadd nvim-cmp]])
	end
	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.completion"] = { config = {
				engine = "nvim-cmp",
			} },
			["core.concealer"] = {},
			["core.qol.todo_items"] = {
				config = {
					create_todo_parents = true
				}
			},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = "~/norg"
					},
					index = "index.norg",
					default_workspace = "notes"
				},
			},
			["core.export"] = { config = { export_dir = "<export-dir>/<language>-export" } },
			["core.export.markdown"] = {},
		},
	})
end

function config.knap()
	local gknapsettings = {
		-- html
		htmloutputext = "html",
		htmltohtml = "none",
		htmltohtmlviewerlaunch =
		"live-server --quiet --browser=chromium --open=%outputfile% --watch=%outputfile% --wait=800",
		htmltohtmlviewerrefresh = "none",
		-- markdown
		mdoutputext = "pdf",
		mdtopdf =
		"pandoc --pdf-engine=xelatex --highlight-style ~/.config/nvim/color/adam.theme --template ~/.config/nvim/color/eisvogel.tex -H ~/.config/nvim/color/head.tex -V CJKmainfont='Noto Serif CJK SC' %docroot% -o %outputfile%",
		mdtopdfviewerlaunch = "zathura %outputfile%",
		mdtopdfviewerrefresh = "kill -HUP %pid%",
		markdownoutputext = "pdf",
		markdowntopdf =
		"pandoc --pdf-engine=xelatex --highlight-style ~/.config/nvim/color/adam.theme --template ~/.config/nvim/color/eisvogel.tex -H ~/.config/nvim/color/head.tex -V CJKmainfont='Noto Serif CJK SC' %docroot% -o %outputfile%",
		markdowntopdfviewerlaunch = "zathura %outputfile%",
		markdowntopdfviewerrefresh = "kill -HUP %pid%",
		-- latex
		texoutputext = "pdf",
		textopdf = "xelatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%",
		textopdfviewerlaunch =
		"zathura --synctex-editor-command 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%",
		textopdfviewerrefresh = "none",
		textopdfforwardjump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
		textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
		delay = 250,
	}
	vim.g.knap_settings = gknapsettings
	vim.api.nvim_create_user_command('KnapOpen', require("knap").process_once, {})
	vim.api.nvim_create_user_command('KnapClose', require("knap").close_viewer, {})
	vim.api.nvim_create_user_command('KnapToggle', require("knap").toggle_autopreviewing, {})
	vim.api.nvim_create_user_command('KnapJump', require("knap").forward_jump, {})
end

function config.coq()
	local util = require("lspconfig.util")
	require 'coq-lsp'.setup({
		lsp = {
			on_attach = function(client, bufnr)
				custom_attach(client);
			end,
			root_dir = util.find_git_ancestor,
			init_options = {
				show_notices_as_diagnostics = false,
				capabilities = capabilities,
			},
		}
	})
end

return config
