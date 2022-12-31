local config = {}

function config.lspsaga()
	local icons = {
		diagnostics = require("modules.ui.icons").get("diagnostics", true),
		kind = require("modules.ui.icons").get("kind", true),
		type = require("modules.ui.icons").get("type", true),
		ui = require("modules.ui.icons").get("ui", true),
	}

	local function set_sidebar_icons()
		-- Set icons for sidebar.
		local diagnostic_icons = {
			Error = icons.diagnostics.Error_alt,
			Warn = icons.diagnostics.Warning_alt,
			Info = icons.diagnostics.Information_alt,
			Hint = icons.diagnostics.Hint_alt,
		}
		for type, icon in pairs(diagnostic_icons) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl })
		end
	end

	local function get_palette()
		if vim.g.colors_name == "catppuccin" then
			-- If the colorscheme is catppuccin then use the palette.
			return require("catppuccin.palettes").get_palette()
		else
			-- Default behavior: return lspsaga's default palette.
			local palette = require("lspsaga.lspkind").colors
			palette.peach = palette.orange
			palette.flamingo = palette.orange
			palette.rosewater = palette.yellow
			palette.mauve = palette.violet
			palette.sapphire = palette.blue
			palette.maroon = palette.orange

			return palette
		end
	end

	set_sidebar_icons()

	local colors = get_palette()

	require("lspsaga").init_lsp_saga({
		diagnostic_header = {
			icons.diagnostics.Error_alt,
			icons.diagnostics.Warning_alt,
			icons.diagnostics.Information_alt,
			icons.diagnostics.Hint_alt,
		},
		custom_kind = {
			-- Kind
			Class = { icons.kind.Class, colors.yellow },
			Constant = { icons.kind.Constant, colors.peach },
			Constructor = { icons.kind.Constructor, colors.sapphire },
			Enum = { icons.kind.Enum, colors.yellow },
			EnumMember = { icons.kind.EnumMember, colors.teal },
			Event = { icons.kind.Event, colors.yellow },
			Field = { icons.kind.Field, colors.teal },
			File = { icons.kind.File, colors.rosewater },
			Function = { icons.kind.Function, colors.blue },
			Interface = { icons.kind.Interface, colors.yellow },
			Key = { icons.kind.Keyword, colors.red },
			Method = { icons.kind.Method, colors.blue },
			Module = { icons.kind.Module, colors.blue },
			Namespace = { icons.kind.Namespace, colors.blue },
			Number = { icons.kind.Number, colors.peach },
			Operator = { icons.kind.Operator, colors.sky },
			Package = { icons.kind.Package, colors.blue },
			Property = { icons.kind.Property, colors.teal },
			Struct = { icons.kind.Struct, colors.yellow },
			TypeParameter = { icons.kind.TypeParameter, colors.maroon },
			Variable = { icons.kind.Variable, colors.peach },
			-- Type
			Array = { icons.type.Array, colors.peach },
			Boolean = { icons.type.Boolean, colors.peach },
			Null = { icons.type.Null, colors.yellow },
			Object = { icons.type.Object, colors.yellow },
			String = { icons.type.String, colors.green },
			-- ccls-specific iconss.
			TypeAlias = { icons.kind.TypeAlias, colors.green },
			Parameter = { icons.kind.Parameter, colors.blue },
			StaticMethod = { icons.kind.StaticMethod, colors.peach },
		},
		code_action_lightbulb = {
			enable = false,
			enable_in_insert = true,
			cache_code_action = true,
			sign = true,
			update_time = 150,
			sign_priority = 20,
			virtual_text = true,
		},
		symbol_in_winbar = {
			enable = true,
			in_custom = false,
			separator = " " .. icons.ui.Separator,
			show_file = false,
			-- define how to customize filename, eg: %:., %
			-- if not set, use default value `%:t`
			-- more information see `vim.fn.expand` or `expand`
			-- ## only valid after set `show_file = true`
			file_formatter = "",
			click_support = function(node, clicks, button, modifiers)
				-- To see all avaiable details: vim.pretty_print(node)
				local st = node.range.start
				local en = node.range["end"]
				if button == "l" then
					if clicks == 2 then
					-- double left click to do nothing
					else -- jump to node's starting line+char
						vim.fn.cursor(st.line + 1, st.character + 1)
					end
				elseif button == "r" then
					if modifiers == "s" then
						print("lspsaga") -- shift right click to print "lspsaga"
					end -- jump to node's ending line+char
					vim.fn.cursor(en.line + 1, en.character + 1)
				elseif button == "m" then
					-- middle click to visual select node
					vim.fn.cursor(st.line + 1, st.character + 1)
					vim.api.nvim_command([[normal v]])
					vim.fn.cursor(en.line + 1, en.character + 1)
				end
			end,
		},
	})
end

function config.cmp()
	local icons = {
		kind = require("modules.ui.icons").get("kind", false),
		type = require("modules.ui.icons").get("type", false),
		cmp = require("modules.ui.icons").get("cmp", false),
	}
	vim.cmd([[packadd nvim-cmp]])
	vim.cmd([[packadd cmp-nvim-ultisnips]])
	vim.cmd([[packadd cmp-tabnine]])

	require("cmp_nvim_ultisnips").setup({ show_snippets = "all" })

	local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

	local types = require("cmp.types")
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	cmp.setup({
		sorting = {
			comparators = {
				require("cmp_tabnine.compare"),
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
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					symbol_map = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp),
				})(entry, vim_item)
				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. strings[1] .. " "
				kind.menu = "    (" .. strings[2] .. ")"
				return kind
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
