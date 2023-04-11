local completion = {}
local conf = require("modules.completion.config")
completion["neovim/nvim-lspconfig"] = {
	opt = false,
	config = conf.nvim_lsp,
}
completion["creativenull/efmls-configs-nvim"] = {
	opt = false,
	requires = "neovim/nvim-lspconfig",
}
completion["williamboman/mason.nvim"] = {
	opt = false,
	requires = {
		{ "williamboman/mason-lspconfig.nvim",},
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", config = conf.mason_install },
	},
}
completion["glepnir/lspsaga.nvim"] = {
	opt = true,
	event = "LspAttach",
	config = conf.lspsaga,
}
completion["ray-x/lsp_signature.nvim"] = { opt = true, after = "nvim-lspconfig" }
completion["hrsh7th/nvim-cmp"] = {
	config = conf.cmp,
 	event = { "VimEnter" },
	requires = {
		{ "onsails/lspkind.nvim" },
		{ "lukas-reineke/cmp-under-comparator" },
		{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
		{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
		{ "ray-x/cmp-treesitter", after = "nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer", after = "cmp-path" },
		{ "hrsh7th/cmp-calc", after = "cmp-path" },
		{ "kdheepak/cmp-latex-symbols",after = "cmp-calc"},
		{ "hrsh7th/cmp-emoji",ft={"markdown","tex"}},
		-- { "jcdickinson/codeium.nvim",
		--  	event = "InsertEnter",
		-- 	config=conf.codeium,
		-- },
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			event = "InsertEnter",
			config = conf.tabnine,
		},
	},
}
completion["L3MON4D3/LuaSnip"] = {
	after = "nvim-cmp",
	config = conf.luasnip,
	requires = "rafamadriz/friendly-snippets",
}
completion["windwp/nvim-autopairs"] = {
	after = "nvim-cmp",
	config = conf.autopairs,
}

return completion
