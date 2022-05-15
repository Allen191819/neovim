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
completion["williamboman/nvim-lsp-installer"] = {
	opt = false,
}
completion["tami5/lspsaga.nvim"] = {
	opt = true,
	after = "nvim-lspconfig",
	config = conf.lspsaga,
}
completion["onsails/lspkind-nvim"] = { opt = false, config = conf.lspkind }
completion["ray-x/lsp_signature.nvim"] = { opt = true, after = "nvim-lspconfig" }
completion["hrsh7th/nvim-cmp"] = {
	config = conf.cmp,
	requires = {
		{ "lukas-reineke/cmp-under-comparator" },
		{ "quangnguyen30192/cmp-nvim-ultisnips" },
		{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path", after = "cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer", after = "cmp-path" },
		{ "hrsh7th/cmp-calc", after = "cmp-path" },
		{ "kdheepak/cmp-latex-symbols", ft = { "markdown", "tex", "lean" } },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql" } },
		{ "hrsh7th/cmp-emoji", ft = { "markdown" } },
		{ "octaltree/cmp-look", after = "nvim-cmp" },
		--{"hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp"},
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			event = "InsertEnter",
			config = conf.tabnine,
		},
	},
}
completion["zbirenbaum/copilot-cmp"] = {
	opt = true,
	after = { "copilot.lua", "nvim-cmp" },
}
completion["zbirenbaum/copilot.lua"] = {
	opt = true,
	event = { "VimEnter" },
	config = conf.copilot_cmp,
}
completion["SirVer/ultisnips"] = {
	opt = false,
	config = conf.ultisnips,
	requires = "Allen191819/vim-snippets",
}
completion["windwp/nvim-autopairs"] = {
	after = "nvim-cmp",
	config = conf.autopairs,
}
completion["Julian/lean.nvim"] = {
	opt = true,
	config = conf.lean,
	after = { "nvim-treesitter", "nvim-lspconfig" },
}
completion["kristijanhusak/vim-dadbod-completion"] = {
	opt = true,
	config = conf.dadbod,
	after = "nvim-lspconfig",
}

-- completion["kosayoda/nvim-lightbulb"] = {
-- 	opt = true,
-- 	after = "nvim-lspconfig",
-- 	config = conf.lightbulb,
-- }
-- completion["github/copilot.vim"] = {
--     opt = true,
--     --    cmd = "Copilot",
--     event = "InsertEnter",
--     config = conf.copilot
-- }

return completion
