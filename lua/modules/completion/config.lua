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

	set_sidebar_icons()

	require("lspsaga").setup({
		preview = {
			lines_above = 1,
			lines_below = 12,
		},
		scroll_preview = {
			scroll_down = "<C-j>",
			scroll_up = "<C-k>",
		},
		request_timeout = 3000,
		finder = {
			edit = { "o", "<CR>" },
			vsplit = "s",
			split = "i",
			tabe = "t",
			quit = { "q", "<ESC>" },
		},
		definition = {
			edit = "<C-c>o",
			vsplit = "<C-c>v",
			split = "<C-c>s",
			tabe = "<C-c>t",
			quit = "q",
			close = "<Esc>",
		},
		code_action = {
			num_shortcut = true,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = false,
			sign = true,
			enable_in_insert = true,
			sign_priority = 20,
			virtual_text = true,
		},
		diagnostic = {
			twice_into = false,
			show_code_action = false,
			show_source = true,
			keys = {
				exec_action = "<CR>",
				quit = "q",
				go_action = "g",
			},
		},
		rename = {
			quit = "<C-c>",
			exec = "<CR>",
			mark = "x",
			confirm = "<CR>",
			whole_project = true,
			in_select = true,
		},
		outline = {
			win_position = "right",
			win_with = "_sagaoutline",
			win_width = 30,
			show_detail = true,
			auto_preview = false,
			auto_refresh = true,
			auto_close = true,
			keys = {
				jump = "<CR>",
				expand_collapse = "u",
				quit = "q",
			},
		},
		symbol_in_winbar = {
			in_custom = true,
			enable = false,
			separator = " " .. icons.ui.Separator,
			hide_keyword = true,
			show_file = false,
			color_mode = true,
		},
		ui = {
			theme = "round",
			border = "single", -- Can be single, double, rounded, solid, shadow.
			winblend = 0,
			expand = icons.ui.ArrowClosed,
			collapse = icons.ui.ArrowOpen,
			preview = icons.ui.Newspaper,
			code_action = icons.ui.CodeAction,
			diagnostic = icons.ui.Bug,
			incoming = icons.ui.Incoming,
			outgoing = icons.ui.Outgoing,
			kind = {
				-- Kind
				Class = { icons.kind.Class },
				Constant = { icons.kind.Constant },
				Constructor = { icons.kind.Constructor },
				Enum = { icons.kind.Enum },
				EnumMember = { icons.kind.EnumMember },
				Event = { icons.kind.Event },
				Field = { icons.kind.Field },
				File = { icons.kind.File },
				Function = { icons.kind.Function },
				Interface = { icons.kind.Interface },
				Key = { icons.kind.Keyword },
				Method = { icons.kind.Method },
				Module = { icons.kind.Module },
				Namespace = { icons.kind.Namespace },
				Number = { icons.kind.Number },
				Operator = { icons.kind.Operator },
				Package = { icons.kind.Package },
				Property = { icons.kind.Property },
				Struct = { icons.kind.Struct },
				TypeParameter = { icons.kind.TypeParameter },
				Variable = { icons.kind.Variable },
				-- Type
				Array = { icons.type.Array },
				Boolean = { icons.type.Boolean },
				Null = { icons.type.Null },
				Object = { icons.type.Object },
				String = { icons.type.String },
				-- ccls-specific icons.
				TypeAlias = { icons.kind.TypeAlias },
				Parameter = { icons.kind.Parameter },
				StaticMethod = { icons.kind.StaticMethod },
				-- Microsoft-specific icons.
				Text = { icons.kind.Text },
				Snippet = { icons.kind.Snippet },
				Folder = { icons.kind.Folder },
				Unit = { icons.kind.Unit },
				Value = { icons.kind.Value },
			},
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
	-- vim.cmd([[packadd cmp-tabnine]])

	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local border = function(hl)
		return {
			{ "╭", hl },
			{ "─", hl },
			{ "╮", hl },
			{ "│", hl },
			{ "╯", hl },
			{ "─", hl },
			{ "╰", hl },
			{ "│", hl },
		}
	end

	local cmp_window = require("cmp.utils.window")

	cmp_window.info_ = cmp_window.info
	cmp_window.info = function(self)
		local info = self:info_()
		info.scrollable = false
		return info
	end
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local compare = require("cmp.config.compare")
	local types = require("cmp.types")
	compare.lsp_scores = function(entry1, entry2)
		local diff
		if entry1.completion_item.score and entry2.completion_item.score then
			diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
		else
			diff = entry2.score - entry1.score
		end
		return (diff < 0)
	end
	cmp.setup({
		window = {
			completion = {
				-- border = border("Normal"),
				max_width = 80,
				max_height = 20,
			},
			documentation = {
				-- border = border("CmpDocBorder"),
			},
		},
		sorting = {
			comparators = {
				-- require("cmp_tabnine.compare"),
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
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-e>"] = cmp.mapping.close(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif require("luasnip").expand_or_jumpable() then
					vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif require("luasnip").jumpable(-1) then
					vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp", max_item_count = 4 },
			{ name = "nvim_lua", max_item_count = 2 },
			{ name = "luasnip", max_item_count = 3 },
			{ name = "treesitter", max_item_count = 3 },
			{ name = "path", max_item_count = 3 },
			{ name = "calc", max_item_count = 1 },
			{ name = "buffer", max_item_count = 3 },
			{ name = "latex_symbols", max_item_count = 5 },
		--	{ name = "cmp_tabnine", max_item_count = 3 },
			{ name = "emoji", max_item_count = 5 },
			{ name = "neorg", max_item_count = 5 },
			{ name = "codeium", max_item_count = 2 ,priority = 20},
		},
		experimental = { native_menu = false, ghost_text = true },
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

function config.codeium()
	require("codeium").setup({})
end

function config.luasnip()
	local snippet_path = os.getenv("HOME") .. "/.config/nvim/snippets/"
	if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
		vim.opt.rtp:append(snippet_path)
	end

	require("luasnip").config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
	})
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
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
