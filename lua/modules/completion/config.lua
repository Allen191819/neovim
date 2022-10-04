local config = {}

function config.lspkind()
	local lspkind = require("lspkind")
	lspkind.init({
		mode = "symbol_text",
		preset = "codicons",
		symbol_map = {
			Text = "",
			Method = "",
			Function = "",
			Constructor = "",
			Field = "ﰠ",
			Variable = "",
			Class = "𝓒",
			Interface = "ﰮ",
			Module = "",
			Property = "ﰠ",
			Unit = "塞",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "פּ",
			Event = "",
			Operator = "",
			TypeParameter = "𝙏",
		},
	})
end

function config.cmp()
	if not packer_plugins["nvim-cmp"].loaded then
		vim.cmd([[packadd nvim-cmp]])
	end

	if not packer_plugins["cmp-nvim-ultisnips"].loaded then
		vim.cmd([[packadd cmp-nvim-ultisnips]])
	end

	if not packer_plugins["cmp-tabnine"].loaded then
		vim.cmd([[packadd cmp-tabnine]])
	end

	vim.cmd([[highlight CmpItemAbbrDeprecated guifg=#D8DEE9 guibg=NONE gui=strikethrough]])
	vim.cmd([[highlight CmpItemKindSnippet guifg=#BF616A guibg=NONE]])
	vim.cmd([[highlight CmpItemKindUnit guifg=#D08770 guibg=NONE]])
	vim.cmd([[highlight CmpItemKindProperty guifg=#A3BE8C guibg=NONE]])
	vim.cmd([[highlight CmpItemKindKeyword guifg=#EBCB8B guibg=NONE]])
	vim.cmd([[highlight CmpItemAbbrMatch guifg=#5E81AC guibg=NONE]])
	vim.cmd([[highlight CmpItemAbbrMatchFuzzy guifg=#5E81AC guibg=NONE]])
	vim.cmd([[highlight CmpItemKindVariable guifg=#8FBCBB guibg=NONE]])
	vim.cmd([[highlight CmpItemKindInterface guifg=#88C0D0 guibg=NONE]])
	vim.cmd([[highlight CmpItemKindText guifg=#81A1C1 guibg=NONE]])
	vim.cmd([[highlight CmpItemKindFunction guifg=#B48EAD guibg=NONE]])
	vim.cmd([[highlight CmpItemKindMethod guifg=#B48EAD guibg=NONE]])

	require("cmp_nvim_ultisnips").setup({ show_snippets = "all" })
	local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
	local types = require("cmp.types")
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local source_menu = {
		cmp_tabnine = "[TN]",
		buffer = "[BUF]",
		nvim_lsp = "[LSP]",
		nvim_lua = "[LUA]",
		path = "[PATH]",
		tmux = "[TMUX]",
		ultisnips = "[SNIP]",
		spell = "[SPELL]",
		emoji = "[Emoji]",
		calc = "[Calc]",
		vim_dadbod_completion = "[DB]",
		latex_symbols = "[Latex]",
		-- copilot = "[AI]",
		orgmode = "[Org]",
		look = "Dict",
		neorg = "Event",
	}
	cmp.setup({
		sorting = {
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				require("cmp-under-comparator").under,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		formatting = {
			format = function(entry, vim_item)
				vim_item.kind = lspkind.presets.default[vim_item.kind]
				local menu = source_menu[entry.source.name]
				if entry.source.name == "cmp_tabnine" then
					local detail = (entry.completion_item.data or {}).detail
					vim_item.kind = ""
					if detail and detail:find(".*%%.*") then
						vim_item.kind = vim_item.kind .. " " .. detail
					end
					if (entry.completion_item.data or {}).multiline then
						vim_item.kind = vim_item.kind .. " " .. "[ML]"
					end
				end
				-- if entry.source.name == "copilot" then
				-- 	if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
				-- 		menu = entry.completion_item.data.detail .. " " .. menu
				-- 	end
				-- 	vim_item.kind = ""
				-- end
				if entry.source.name == "look" then
					if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
						menu = entry.completion_item.data.detail .. " " .. menu
					end
					vim_item.kind = "﬜"
				end
				if entry.source.name == "neorg" then
					if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
						menu = entry.completion_item.data.detail .. " " .. menu
					end
					vim_item.kind = ""
				end
				vim_item.menu = menu
				return vim_item
			end,
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if require("neogen").jumpable() then
					require("neogen").jump_next()
				else
					cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if require("neogen").jumpable(true) then
					require("neogen").jump_prev()
				else
					cmp_ultisnips_mappings.jump_backwards(fallback)
				end
			end, { "i", "s" }),
		},
		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp", group_index = 2, max_item_count = 4 },
			{ name = "nvim_lua", group_index = 2, max_item_count = 2 },
			{ name = "ultisnips", group_index = 1, max_item_count = 3 },
			{ name = "path", group_index = 2, max_item_count = 3 },
			{ name = "calc", group_index = 2, max_item_count = 1 },
			{ name = "buffer", group_index = 2, max_item_count = 3 },
			{ name = "latex_symbols", group_index = 2, max_item_count = 5 },
			{ name = "vim_dadbod_completion", group_index = 2, max_item_count = 3 },
			{ name = "cmp_tabnine", group_index = 2, max_item_count = 3 },
			--{ name = "copilot", group_index = 2, max_item_count = 3 },
			{ name = "emoji", group_index = 2, max_item_count = 5 },
			{ name = "neorg", group_index = 2, max_item_count = 5 },
			{
				name = "look",
				group_index = 2,
				max_item_count = 3,
				option = {
					convert_case = true,
					loud = true,
				},
			},
		},
		experimental = { native_menu = false, ghost_text = false },
		preselect = types.cmp.PreselectMode.Item,
		completion = {
			autocomplete = { types.cmp.TriggerEvent.TextChanged },
			completeopt = "menu,menuone,noselect",
			keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
			keyword_length = 2,
			get_trigger_characters = function(trigger_characters)
				return trigger_characters
			end,
		},
	})
end

function config.ultisnips()
	vim.api.nvim_exec(
		[[
	autocmd BufWritePost *.snippets :CmpUltisnipsReloadSnippets
	]],
		true
	)
	vim.g.UltiSnipsRemoveSelectModeMappings = 0
	vim.g.UltiSnipsEditSplit = "vertical"
	vim.cmd([[
	let g:UltiSnipsSnippetDirectories=[$HOME."/.config/nvim/ultsnips"]
	]])
end

function config.tabnine()
	local tabnine = require("cmp_tabnine.config")
	tabnine:setup({ max_line = 200, max_num_results = 20, sort = true })
end

function config.autopairs()
	local npairs = require("nvim-autopairs")
	local Rule = require("nvim-autopairs.rule")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	local handlers = require("nvim-autopairs.completion.handlers")
	npairs.setup()
	npairs.add_rule(Rule("$$", "$$", "tex"))
	cmp.event:on(
		"confirm_done",
		cmp_autopairs.on_confirm_done({
			filetypes = {
				["*"] = {
					["("] = {
						kind = {
							cmp.lsp.CompletionItemKind.Function,
							cmp.lsp.CompletionItemKind.Method,
						},
						handler = handlers["*"],
					},
				},
				tex = false,
			},
		})
	)
end

-- function config.copilot()
-- 	vim.cmd([[ imap <silent><script><expr> <A-h> copilot#Accept("\<CR>") ]])
-- 	vim.cmd([[ let g:copilot_no_tab_map = v:true ]])
-- 	vim.cmd([[ highlight CopilotSuggestion guifg=#EBCB8B ctermfg=8 ]])
-- end

-- function config.copilot_cmp()
-- 	require("copilot").setup()
-- end

function config.lspsaga()
	local lspsaga = require("lspsaga")
	lspsaga.setup({
		debug = false,
		use_saga_diagnostic_sign = false,
		diagnostic_header_icon = "   ",
		code_action_icon = " ",
		code_action_prompt = {
			enable = false,
			sign = false,
			sign_priority = 10,
			virtual_text = false,
		},
		finder_definition_icon = "  ",
		finder_reference_icon = "  ",
		max_preview_lines = 10,
		finder_action_keys = {
			open = "o",
			vsplit = "s",
			split = "i",
			quit = "q",
			scroll_down = "<C-f>",
			scroll_up = "<C-b>",
		},
		code_action_keys = {
			quit = "q",
			exec = "<CR>",
		},
		rename_action_keys = {
			quit = "<C-c>",
			exec = "<CR>",
		},
		definition_preview_icon = "  ",
		border_style = "rounded",
		rename_prompt_prefix = "➤",
		rename_output_qflist = {
			enable = true,
			auto_open_qflist = true,
		},
		server_filetype_map = {},
		diagnostic_prefix_format = "%d. ",
		diagnostic_message_format = "%m %c",
		highlight_prefix = true,
	})
end

function config.nvim_lsp()
	require("modules.completion.lsp")
end

function config.mason_install()
	require("mason-tool-installer").setup({
		ensure_installed = {
			"editorconfig-checker",
			"stylua",
			"black",
			"prettier",
			"shellcheck",
			"shfmt",
			"vint",
		},
		auto_update = false,
		run_on_start = true,
	})
end

return config
