local lang = {}
local conf = require("modules.lang.config")

lang["fatih/vim-go"] = {
	opt = true,
	ft = "go",
	run = ":GoInstallBinaries",
	config = conf.lang_go,
}
lang["simrat39/rust-tools.nvim"] = {
	opt = true,
	ft = "rust",
	config = conf.rust_tools,
}
lang["mattn/webapi-vim"] = {
	opt = true,
	ft = "rust",
}
lang["chrisbra/csv.vim"] = { opt = true, ft = "csv" }
lang["toppair/peek.nvim"] = {
	opt = true,
	ft = "markdown",
	run = "deno task --quiet build:fast",
	config = conf.peek,
}
lang["dhruvasagar/vim-table-mode"] = { opt = true, ft = "markdown" }
lang["mzlogin/vim-markdown-toc"] = { opt = true, ft = "markdown" }
lang["ekickx/clipboard-image.nvim"] = {
	opt = true,
	commit = "f678fb378c049cd3f6b0a187014e9bc3bbd09706",
	cmd = { "PasteImg" },
	ft = "markdown",
	config = conf.clipboard_image,
}
lang["nvim-neorg/neorg"] = { opt = true, cmd = "Neorg", ft = "norg", config = conf.norg }
lang["whonore/Coqtail"] = { opt = true, ft = "coq" }
lang["frabjous/knap"] = { opt = true, ft = { "markdown", "tex", "html" }, config = conf.knap, require = { "savq/paq-nvim" } }
return lang
