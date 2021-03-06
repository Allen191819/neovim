local formatting = require("modules.completion.formatting")
vim.cmd([[packadd cmp-nvim-lsp]])

if not packer_plugins["nvim-lsp-installer"].loaded then
	vim.cmd([[packadd nvim-lsp-installer]])
end

if not packer_plugins["lsp_signature.nvim"].loaded then
	vim.cmd([[packadd lsp_signature.nvim]])
end

if not packer_plugins["cmp-nvim-lsp"].loaded then
	vim.cmd([[packadd cmp-nvim-lsp]])
end
if not packer_plugins["lspsaga.nvim"].loaded then
	vim.cmd([[packadd lspsaga.nvim]])
end

local nvim_lsp = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")

local signs = { Error = "✗", Warn = "", Hint = "", Info = "" }
local lspconfig_window = require("lspconfig.ui.windows")

local old_defaults = lspconfig_window.default_opts

function lspconfig_window.default_opts(opts)
	local win_opts = old_defaults(opts)
	win_opts.border = "rounded"
	return win_opts
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lsp-installer",
	callback = function()
		vim.api.nvim_win_set_config(0, { border = "rounded" })
	end,
})

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
-- Override default format setting
vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
	if err ~= nil or result == nil then
		return
	end
	if
		vim.api.nvim_buf_get_var(ctx.bufnr, "init_changedtick") == vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick")
	then
		local view = vim.fn.winsaveview()
		vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-16")
		vim.fn.winrestview(view)
		if ctx.bufnr == vim.api.nvim_get_current_buf() then
			vim.b.saving_format = true
			vim.cmd([[update]])
			vim.b.saving_format = false
		end
	end
end

lsp_installer.settings({
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.documentationFormat = {
	"markdown",
	"plaintext",
}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = {
	valueSet = { 1 },
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
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
		underline = false,
		update_in_insert = false,
		severity_sort = true,
	})
end

local function switch_source_header_splitcmd(bufnr, splitcmd)
	bufnr = nvim_lsp.util.validate_bufnr(bufnr)
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	vim.lsp.buf_request(bufnr, "textDocument/switchSourceHeader", params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			print("Corresponding file can’t be determined")
			return
		end
		vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
	end)
end

-- Override server settings here

local enhance_server_opts = {
	["sqls"] = function(opts)
		opts.cmd = { "sqls" }
		opts.args = { "-config ~/.config/sqls/config.yml" }
		opts.filetypes = { "sql", "mysql" }
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["sumneko_lua"] = function(opts)
		opts.settings = {
			Lua = {
				diagnostics = { globals = { "vim", "packer_plugins" } },
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
				telemetry = { enable = false },
			},
		}
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["clangd"] = function(opts)
		opts.args = {
			"--background-index",
			"-std=c++20",
			"--pch-storage=memory",
			"--clang-tidy",
			"--suggest-missing-includes",
		}
		opts.capabilities.offsetEncoding = { "utf-16" }
		opts.single_file_support = true
		opts.commands = {
			ClangdSwitchSourceHeader = {
				function()
					switch_source_header_splitcmd(0, "edit")
				end,
				description = "Open source/header in current buffer",
			},
			ClangdSwitchSourceHeaderVSplit = {
				function()
					switch_source_header_splitcmd(0, "vsplit")
				end,
				description = "Open source/header in a new vsplit",
			},
			ClangdSwitchSourceHeaderSplit = {
				function()
					switch_source_header_splitcmd(0, "split")
				end,
				description = "Open source/header in a new split",
			},
		}
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["jsonls"] = function(opts)
		opts.settings = {
			json = {
				-- Schemas https://www.schemastore.org
				schemas = {
					{
						fileMatch = { "package.json" },
						url = "https://json.schemastore.org/package.json",
					},
					{
						fileMatch = { "tsconfig*.json" },
						url = "https://json.schemastore.org/tsconfig.json",
					},
					{
						fileMatch = {
							".prettierrc",
							".prettierrc.json",
							"prettier.config.json",
						},
						url = "https://json.schemastore.org/prettierrc.json",
					},
					{
						fileMatch = { ".eslintrc", ".eslintrc.json" },
						url = "https://json.schemastore.org/eslintrc.json",
					},
					{
						fileMatch = {
							".babelrc",
							".babelrc.json",
							"babel.config.json",
						},
						url = "https://json.schemastore.org/babelrc.json",
					},
					{
						fileMatch = { "lerna.json" },
						url = "https://json.schemastore.org/lerna.json",
					},
					{
						fileMatch = {
							".stylelintrc",
							".stylelintrc.json",
							"stylelint.config.json",
						},
						url = "http://json.schemastore.org/stylelintrc.json",
					},
					{
						fileMatch = { "/.github/workflows/*" },
						url = "https://json.schemastore.org/github-workflow.json",
					},
				},
			},
		}
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
	["tsserver"] = function(opts)
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["dockerls"] = function(opts)
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["pylsp"] = function(opts)
		opts.settings = {
			pylsp = {
				pylint = { enabled = false },
				flake8 = { enabled = false },
				pycodestyle = { enabled = true },
				pyflakes = { enabled = false },
				yapf = { enabled = true },
			},
		}
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
	["r_language_server"] = function(opts)
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
	["remark_ls"] = function(opts)
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = false
			custom_attach(client)
		end
	end,
	["jdtls"] = function(opts)
		opts.single_file_support = true
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
	["phpactor"] = function(opts)
		opts.single_file_support = true
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
	["vimls"] = function(opts)
		opts.single_file_support = true
		opts.on_attach = function(client)
			client.server_capabilities.document_formatting = true
			custom_attach(client)
		end
	end,
}
lsp_installer.on_server_ready(function(server)
	local opts = {
		capabilities = capabilities,
		flags = { debounce_text_changes = 500 },
		on_attach = custom_attach,
	}
	if enhance_server_opts[server.name] then
		enhance_server_opts[server.name](opts)
	end
	server:setup(opts)
end)

-- https://github.com/vscode-langservers/vscode-html-languageserver-bin

nvim_lsp.html.setup({
	cmd = { "vscode-html-languageserver", "--stdio" },
	filetypes = { "html", "htmldjango" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
	},
	settings = {},
	single_file_support = true,
	flags = { debounce_text_changes = 500 },
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		custom_attach(client)
	end,
})
nvim_lsp.hls.setup({
	single_file_support = true,
	flags = { debounce_text_changes = 500 },
	capabilities = capabilities,
	on_attach = function(client)
		require("aerial").on_attach(client)
		client.server_capabilities.document_formatting = true
		custom_attach(client)
	end,
})

local efmls = require("efmls-configs")

-- Init `efm-langserver` here.

efmls.init({
	on_attach = custom_attach,
	capabilities = capabilities,
	init_options = { documentFormatting = true, codeAction = true },
})

-- Require `efmls-configs-nvim`'s config here

local vint = require("efmls-configs.linters.vint")
local clangtidy = require("efmls-configs.linters.clang_tidy")
local eslint = require("efmls-configs.linters.eslint")
local flake8 = require("efmls-configs.linters.flake8")
local shellcheck = require("efmls-configs.linters.shellcheck")
local staticcheck = require("efmls-configs.linters.staticcheck")
local luafmt = require("efmls-configs.formatters.stylua")
local clangfmt = require("efmls-configs.formatters.clang_format")
local goimports = require("efmls-configs.formatters.goimports")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("efmls-configs.formatters.shfmt")
local alex = require("efmls-configs.linters.alex")
local pylint = require("efmls-configs.linters.pylint")
local yapf = require("efmls-configs.formatters.yapf")
local vulture = require("efmls-configs.linters.vulture")

-- Add your own config for formatter and linter here

local rustfmt = require("modules.completion.efm.formatters.rustfmt")
local sqlfmt = require("modules.completion.efm.formatters.sqlfmt")

-- Override default config here

flake8 = vim.tbl_extend("force", flake8, {
	prefix = "flake8: max-line-length=160, ignore F403 and F405",
	lintStdin = true,
	lintIgnoreExitCode = true,
	lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
	lintCommand = "flake8 --max-line-length 160 --extend-ignore F403,F405 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
})

-- Setup formatter and linter for efmls here

efmls.setup({
	vim = { formatter = vint },
	lua = { formatter = luafmt },
	c = { formatter = clangfmt, linter = clangtidy },
	cpp = { formatter = clangfmt, linter = clangtidy },
	-- go = { formatter = goimports, linter = staticcheck },
	latex = { linter = alex },
	-- python = {formatter = yapf},
	vue = { formatter = prettier },
	typescript = { formatter = prettier, linter = eslint },
	javascript = { formatter = prettier, linter = eslint },
	typescriptreact = { formatter = prettier, linter = eslint },
	javascriptreact = { formatter = prettier, linter = eslint },
	yaml = { formatter = prettier },
	json = { formatter = prettier, linter = eslint },
	html = { formatter = prettier },
	css = { formatter = prettier },
	scss = { formatter = prettier },
	sh = { formatter = shfmt, linter = shellcheck },
	markdown = { formatter = prettier },
	-- rust = { formatter = rustfmt },
	sql = { formatter = sqlfmt },
	htmldjango = { formatter = prettier },
})

formatting.configure_format_on_save()
