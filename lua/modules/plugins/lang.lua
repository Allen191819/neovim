local lang = {}

lang["fatih/vim-go"] = {
	lazy = true,
	ft = "go",
	build = ":GoInstallBinaries",
	config = require("lang.vim-go"),
}
lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["dhruvasagar/vim-table-mode"] = { lazy = true, ft = "markdown" }
lang["mzlogin/vim-markdown-toc"] = { lazy = true, ft = "markdown" }
lang["ekickx/clipboard-image.nvim"] = {
	lazy = true,
	commit = "f678fb378c049cd3f6b0a187014e9bc3bbd09706",
	ft = { "markdown", "tex" },
	config = require("lang.clipboard_image"),
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
lang["tomtomjhj/coq-lsp.nvim"] = {
	opt = true,
	ft = "coq",
	config = require("lang.coq"),
	dependencies = {
		"whonore/Coqtail",
	},
}
lang["frabjous/knap"] = {
	opt = true,
	ft = { "markdown", "tex", "html" },
	config = require("lang.knap"),
	dependencies = { "savq/paq-nvim" },
}
return lang
