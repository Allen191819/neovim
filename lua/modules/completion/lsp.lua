local formatting = require("modules.completion.formatting")
if not packer_plugins["lsp_signature.nvim"].loaded then
	vim.cmd([[packadd lsp_signature.nvim]])
end

if not packer_plugins["cmp-nvim-lsp"].loaded then
	vim.cmd([[packadd cmp-nvim-lsp]])
end
if not packer_plugins["lspsaga.nvim"].loaded then
	vim.cmd([[packadd lspsaga.nvim]])
end
if not packer_plugins["nvim-navic"].loaded then
	vim.cmd([[packadd nvim-navic]])
end

local nvim_lsp = require("lspconfig")
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")

mason.setup()
mason_lsp.setup({
	ensure_installed = {
		"bash-language-server",
		"lua-language-server",
		"clangd",
		"pylsp",
		"vimls",
		"sqls",
		"jsonls",
	},
})

local signs = { Error = "✗", Warn = "", Hint = "", Info = "" }
local lspconfig_window = require("lspconfig.ui.windows")

local old_defaults = lspconfig_window.default_opts

function lspconfig_window.default_opts(opts)
	local win_opts = old_defaults(opts)
	win_opts.border = "rounded"
	return win_opts
end

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

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
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function custom_attach(client, bufnr)
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
			border = "none",
		},
	})
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
	local clangd_client = nvim_lsp.util.get_active_client_by_name(bufnr, "clangd")
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if clangd_client then
		clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				vim.notify("Corresponding file can’t be determined", vim.log.levels.ERROR, { title = "LSP Error!" })
				return
			end
			vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
		end)
	else
		vim.notify(
			"Method textDocument/switchSourceHeader is not supported by any active server on this buffer",
			vim.log.levels.ERROR,
			{ title = "LSP Error!" }
		)
	end
end

-- Override server settings here

for _, server in ipairs(mason_lsp.get_installed_servers()) do
	if server == "sumneko_lua" then
		nvim_lsp.sumneko_lua.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				custom_attach(client, bufnr)
				require("nvim-navic").attach(client, bufnr)
			end,
			settings = {
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
			},
		})
	elseif server == "sqls" then
		nvim_lsp.sqls.setup({
			cmd = { "sqls" },
			args = { "-config ~/.config/sqls/config.yml" },
			filetypes = { "sql", "mysql" },

			on_attach = custom_attach,
		})
	elseif server == "clangd" then
		local copy_capabilities = capabilities
		copy_capabilities.offsetEncoding = { "utf-16" }
		nvim_lsp.clangd.setup({
			capabilities = copy_capabilities,
			single_file_support = true,
			on_attach = function(client, bufnr)
				custom_attach(client, bufnr)
				require("nvim-navic").attach(client, bufnr)
			end,
			cmd = {
				"clangd",
				"--background-index",
				"--pch-storage=memory",
				-- You MUST set this arg ↓ to your clangd executable location (if not included)!
				"--query-driver=/usr/bin/clang++,/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
				"--clang-tidy",
				"--all-scopes-completion",
				"--cross-file-rename",
				"--completion-style=detailed",
				"--header-insertion-decorators",
				"--header-insertion=iwyu",
			},
			commands = {
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
			},
		})
	elseif server == "jsonls" then
		nvim_lsp.jsonls.setup({
			flags = { debounce_text_changes = 500 },
			single_file_support = true,
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				custom_attach(client, bufnr)
				require("nvim-navic").attach(client, bufnr)
			end,
			settings = {
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
			},
		})
	else
		nvim_lsp[server].setup({
			capabilities = capabilities,
			single_file_support = true,
			on_attach = function(client, bufnr)
				custom_attach(client, bufnr)
				require("nvim-navic").attach(client, bufnr)
			end,
		})
	end
end

nvim_lsp.hls.setup({
	cmd = { "haskell-language-server-9.0.2~1.8.0.0", "--lsp" },
	flags = { debounce_text_changes = 500 },
	capabilities = capabilities,
	on_attach = function(client)
		require("aerial").on_attach(client)
		custom_attach(client)
	end,
})

-- https://github.com/jeapostrophe/racket-langserver

nvim_lsp.racket_langserver.setup({
	cmd = {"racket", "--lib", "racket-langserver"},
	filetypes = { "racket", "scheme" },
	single_file_support = true,
	capabilities = capabilities,
	on_attach = function(client,bufnr)
		require("nvim-navic").attach(client, bufnr)
		require("aerial").on_attach(client)
		custom_attach(client)
	end,
})

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
	on_attach = function(client, bufnr)
		custom_attach(client)
		require("nvim-navic").attach(client, bufnr)
	end,
})

local efmls = require("efmls-configs")
-- Init `efm-langserver` here.
efmls.init({
	on_attach = custom_attach,
	init_options = { documentFormatting = true, codeAction = true },
})

-- Require `efmls-configs-nvim`'s config here

-- local vint = require("efmls-configs.linters.vint")
local clangtidy = require("efmls-configs.linters.clang_tidy")
local eslint = require("efmls-configs.linters.eslint")
local flake8 = require("efmls-configs.linters.flake8")
local shellcheck = require("efmls-configs.linters.shellcheck")
-- local staticcheck = require("efmls-configs.linters.staticcheck")
local luafmt = require("efmls-configs.formatters.stylua")
local clangfmt = require("efmls-configs.formatters.clang_format")
-- local goimports = require("efmls-configs.formatters.goimports")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("efmls-configs.formatters.shfmt")
local alex = require("efmls-configs.linters.alex")
-- local pylint = require("efmls-configs.linters.pylint")
-- local yapf = require("efmls-configs.formatters.yapf")
-- local vulture = require("efmls-configs.linters.vulture")

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
	lua = { formatter = luafmt },
	c = { formatter = clangfmt, linter = clangtidy },
	cpp = { formatter = clangfmt, linter = clangtidy },
	latex = { linter = alex },
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
	sql = { formatter = sqlfmt },
	htmldjango = { formatter = prettier },
	-- rust = { formatter = rustfmt },
	-- python = {formatter = yapf},
	-- go = { formatter = goimports, linter = staticcheck },
})

formatting.configure_format_on_save()
