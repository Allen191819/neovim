local completion = {}
local conf = require("modules.completion.config")
completion["neovim/nvim-lspconfig"] = {
	opt = true,
	event = "BufReadPre",
	config = conf.nvim_lsp,
}
completion["creativenull/efmls-configs-nvim"] = {
	opt = false,
	requires = "neovim/nvim-lspconfig",
}
completion["williamboman/mason.nvim"] = {
	requires = {
		{
			"williamboman/mason-lspconfig.nvim",
		},
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
		{ "quangnguyen30192/cmp-nvim-ultisnips" ,after="nvim-cmp"},
		{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer", after = "cmp-path" },
		{ "hrsh7th/cmp-calc", after = "cmp-path" },
		{ "kdheepak/cmp-latex-symbols",after = "cmp-calc"},
		{ "hrsh7th/cmp-emoji",after = "cmp-path" },
		{ "octaltree/cmp-look", after = "nvim-cmp" },
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			event = "InsertEnter",
			config = conf.tabnine,
		},
	},
}
completion["SirVer/ultisnips"] = {
	opt = false,
 	event = { "VimEnter" },
	config = conf.ultisnips,
	requires = "Allen191819/vim-snippets",
}
completion["windwp/nvim-autopairs"] = {
	after = "nvim-cmp",
	config = conf.autopairs,
}
completion["kristijanhusak/vim-dadbod-completion"] = {
	opt = true,
	config = conf.dadbod,
	after = "nvim-cmp",
}
return completion
