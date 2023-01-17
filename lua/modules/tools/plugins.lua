local tools = {}
local conf = require("modules.tools.config")

tools["RishabhRD/popfix"] = { opt = false }
tools["nvim-lua/plenary.nvim"] = { opt = false }
tools["nvim-telescope/telescope.nvim"] = {
	opt = true,
	cmd = "Telescope",
	module = "telescope",
	config = conf.telescope,
	requires = {
		{ "nvim-lua/plenary.nvim", opt = false },
		{ "nvim-lua/popup.nvim", opt = true },
	},
}
tools["ahmedkhalf/project.nvim"] = {
	opt = true,
	after = "telescope.nvim",
}
tools["desdic/telescope-rooter.nvim"] = {
	opt = true,
	after = "telescope.nvim",
}
tools["rcarriga/nvim-notify"] = { opt = false, config = conf.notify }
tools["nvim-telescope/telescope-frecency.nvim"] = {
	opt = true,
	after = "telescope.nvim",
	requires = { { "tami5/sqlite.lua", opt = true } },
}
tools["nvim-telescope/telescope-symbols.nvim"] = {
	opt = true,
	after = "telescope.nvim",
}
tools["nvim-telescope/telescope-live-grep-raw.nvim"] = {
	opt = true,
	after = "telescope.nvim",
}
tools["jvgrootveld/telescope-zoxide"] = {
	opt = true,
	after = "telescope.nvim",
}
tools["MattesGroeger/vim-bookmarks"] = { opt = false, config = conf.bookmarks }
tools["thinca/vim-quickrun"] = {
	opt = true,
	cmd = { "QuickRun", "Q" },
	config = conf.quickrun,
}
tools["michaelb/sniprun"] = {
	opt = true,
	run = "bash ./install.sh",
	cmd = { "SnipRun", "'<,'>SnipRun" },
}
tools["folke/which-key.nvim"] = {
	opt = true,
	key = ',',
	config = conf.which_key,
}
tools["folke/trouble.nvim"] = {
	opt = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = conf.trouble,
}
tools["mbbill/undotree"] = {
	opt = true,
	cmd = "UndotreeToggle",
	config = conf.undotree,
}
tools["Allen191819/lazygit.nvim"] = { opt = true, cmd = "LazyGit" }
tools["gelguy/wilder.nvim"] = {
	event = "CmdlineEnter",
	config = conf.wilder,
	requires = { { "romgrk/fzy-lua-native", after = "wilder.nvim" } },
}
tools["stevearc/aerial.nvim"] = { opt = false, config = conf.aerial }
tools["lambdalisue/suda.vim"] = {
	opt = true,
	cmd = { "SudaRead", "SudaWrite" },
	config = conf.suda,
}
tools["itchyny/calendar.vim"] = {
	opt = false,
}
tools["h-hg/fcitx.nvim"] = { opt = false, event = "VimEnter" }
return tools
