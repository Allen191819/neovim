local config = {}

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
	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
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

function config.makrkdown_preview()
	vim.g.mkdp_auto_start = 0
	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_refresh_slow = 0
	vim.g.mkdp_command_for_global = 0
	vim.g.mkdp_browser = "surf"
	vim.g.mkdp_page_title = "「${name}」"
	vim.g.mkdp_filetypes = { "markdown" }
	vim.g.mkdp_theme = "light"
	vim.g.vmt_auto_update_on_save = 1
	vim.g.mkdp_markdown_css = "/home/allen/.config/nvim/color/markdown.css"
	vim.g.mkdp_highlight_css = "/home/allen/.config/nvim/color/highlight.css"
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

function config.norg()
	if not packer_plugins["nvim-cmp"].loaded then
		vim.cmd([[packadd nvim-cmp]])
	end
	require("neorg").setup({
		load = {
			["core.defaults"] = {},
			["core.norg.completion"] = { config = {
				engine = "nvim-cmp",
			} },
			["core.norg.concealer"] = {},
			["core.norg.dirman"] = {
				config = {
					workspaces = {
						work = "~/norg/work",
						home = "~/norg/home",
						gtd = "~/norg/gtd",
					},
				},
			},
			["core.export"] = { config = {} },
			["core.export.markdown"] = {},
			["core.keybinds"] = {},
			["core.gtd.base"] = {
				config = {
					workspace = "gtd",
				},
			},
			["core.norg.qol.todo_items"] = { config = {} },
		},
	})
end

function config.knap()
	local gknapsettings = {
		htmloutputext = "html",
		htmltohtml = "none",
		htmltohtmlviewerlaunch = "surf %outputfile%",
		htmltohtmlviewerrefresh = "none",
		mdoutputext = "pdf",
		mdtohtml = "pandoc --standalone %docroot% -o %outputfile%",
		mdtohtmlviewerlaunch = "surf %outputfile%",
		mdtohtmlviewerrefresh = "none",
		mdtopdf = "pandoc --pdf-engine=xelatex --highlight-style tango --template ~/.config/nvim/color/eisvogel.tex -V CJKmainfont='Source Han Serif CN' %docroot% -o %outputfile% --listing",
		mdtopdfviewerlaunch = "zathura %outputfile%",
		mdtopdfviewerrefresh = "none",
		markdownoutputext = "pdf",
		markdowntohtml = 'pandoc --standalone %docroot% -o %outputfile% -V mainfont="Source Han Serif CN"',
		markdowntohtmlviewerlaunch = "surf %outputfile%",
		markdowntohtmlviewerrefresh = "none",
		markdowntopdf = "pandoc --pdf-engine=xelatex --highlight-style tango --template ~/.config/nvim/color/eisvogel.tex -V CJKmainfont='Source Han Serif CN' %docroot% -o %outputfile% --listing",
		markdowntopdfviewerlaunch = "zathura %outputfile%",
		markdowntopdfviewerrefresh = "none",
		texoutputext = "pdf",
		textopdf = "xelatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%",
		textopdfviewerlaunch = "zathura --synctex-editor-command 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%",
		textopdfviewerrefresh = "none",
		textopdfforwardjump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
		textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
		delay = 250,
	}
	vim.g.knap_settings = gknapsettings
	vim.cmd([[
	autocmd BufRead,BufNewFile *.tex setlocal spell
	]])
end

return config
