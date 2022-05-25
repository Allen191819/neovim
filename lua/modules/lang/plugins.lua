local lang = {}
local conf = require("modules.lang.config")
lang["ray-x/go.nvim"] = {
	opt = true,
	ft = "go",
	config = conf.lang_go,
	required = {
		"ray-x/guihua.lua",
		run = "cd lua/fzy && make",
		after = "go.nvim",
	},
}
lang["rust-lang/rust.vim"] = { opt = true, ft = "rust" }
lang["simrat39/rust-tools.nvim"] = {
	opt = true,
	ft = "rust",
	config = conf.rust_tools,
	requires = { { "nvim-lua/plenary.nvim", opt = false } },
}
lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }
lang["iamcco/markdown-preview.nvim"] = {
	opt = true,
	ft = "markdown",
	run = "cd app && yarn install",
	config = conf.makrkdown_preview,
}
lang["lervag/vimtex"] = { opt = true, ft = "tex", config = conf.latex }
lang["dhruvasagar/vim-table-mode"] = { opt = true, ft = "markdown" }
lang["mzlogin/vim-markdown-toc"] = { opt = true, ft = "markdown" }
lang["ekickx/clipboard-image.nvim"] = {
	opt = true,
	commit = "f678fb378c049cd3f6b0a187014e9bc3bbd09706",
	cmd = { "PasteImg" },
	ft = "markdown",
	config = conf.clipboard_image,
}
lang["h-hg/fcitx.nvim"] = { opt = false, event = "VimEnter" }
lang["whonore/Coqtail"] = { opt = true, ft = "coq" }
lang["jalvesaq/Nvim-R"] = { opt = true, ft = "r" }
lang["fladson/vim-kitty"] = {
	opt = true,
	ft = "kitty",
}
lang["nvim-neorg/neorg"] = { opt = true, after = "nvim-treesitter", config = conf.neorg }
return lang
