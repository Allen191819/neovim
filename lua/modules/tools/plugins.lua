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
tools["rcarriga/nvim-notify"] = {opt=false,config=conf.notify}
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
tools["fhill2/telescope-ultisnips.nvim"] = { opt = true, after = "telescope.nvim" }
tools["tom-anders/telescope-vim-bookmarks.nvim"] = { opt = true, after = "telescope.nvim" }
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
	keys = ",",
	config = function()
		require("which-key").setup({})
	end,
}
tools["folke/trouble.nvim"] = {
	opt = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = conf.trouble,
}
tools["sindrets/diffview.nvim"] = {
	opt = true,
	cmd = { "DiffviewFileHistory", "DiffviewOpen" },
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
tools["kristijanhusak/vim-dadbod-ui"] = {
	opt = true,
	cmd = { "DBUIToggle" },
	requires = { { "tpope/vim-dadbod", opt = true } },
	config = conf.dadbod,
}
tools["lambdalisue/suda.vim"] = {
	opt = true,
	cmd = { "SudaRead", "SudaWrite" },
	config = conf.suda,
}
tools["itchyny/calendar.vim"] = {
	opt=false
}
return tools
