local editor = {}
local conf = require("modules.editor.config")
editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }
editor["RRethy/vim-illuminate"] = {
	opt = true,
	event = "BufReadPost",
	config = conf.illuminate,
}
editor["terrortylor/nvim-comment"] = {
	opt = true,
	event = { "VimEnter" },
	config = function()
		require("nvim_comment").setup({
			hook = function()
				require("ts_context_commentstring.internal").update_commentstring()
			end,
		})
	end,
}
editor["nvim-treesitter/nvim-treesitter"] = {
	opt = true,
	run = ":TSUpdate",
	event = { "BufReadPost" },
	config = conf.nvim_treesitter,
}
editor["romgrk/nvim-treesitter-context"] = {
	opt = true,
	after = "nvim-treesitter",
}
editor["nvim-treesitter/nvim-treesitter-textobjects"]={opt = true, after = "nvim-treesitter"}
editor["p00f/nvim-ts-rainbow"] = { opt = true, after = "nvim-treesitter" }
editor["JoosepAlviste/nvim-ts-context-commentstring"] = {
	opt = true,
	after = "nvim-treesitter",
}
editor["windwp/nvim-ts-autotag"] = {
	opt = true,
	ft = { "html", "xml" },
	config = conf.autotag,
}
editor["andymass/vim-matchup"] = {
	opt = true,
	after = "nvim-treesitter",
	config = conf.matchup,
}
editor["rhysd/accelerated-jk"] = { opt = true }
editor["hrsh7th/vim-eft"] = { opt = true }
editor["romainl/vim-cool"] = {
	opt = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["phaazon/hop.nvim"] = {
	opt = true,
	branch = "v1",
	cmd = {
		"HopLine",
		"HopLineStart",
		"HopWord",
		"HopPattern",
		"HopChar1",
		"HopChar2",
	},
	config = function()
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
	end,
}
editor["karb94/neoscroll.nvim"] = {
	opt = true,
	event = "WinScrolled",
	config = conf.neoscroll,
}
editor["vimlab/split-term.vim"] = { opt = true, cmd = { "Term", "VTerm" } }
editor["voldikss/vim-floaterm"] = {
	opt = true,
	event = "VimEnter",
	config = conf.floaterm,
}
editor["norcalli/nvim-colorizer.lua"] = {
	opt = false,
	after = "nvim-treesitter",
	config = conf.nvim_colorizer,
}

editor["mfussenegger/nvim-dap"] = {
	opt = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	module = "dap",
	config = conf.dap,
}
editor["rcarriga/nvim-dap-ui"] = {
	opt = true,
	after = "nvim-dap", -- Need to call setup after dap has been initialized.
	config = conf.dapui,
}
editor["tpope/vim-fugitive"] = { opt = true, cmd = { "Git", "G" } }
editor["famiu/bufdelete.nvim"] = {
	opt = true,
	cmd = { "Bdelete", "Bwipeout", "Bdelete!", "Bwipeout!" },
}
editor["edluffy/specs.nvim"] = {
	opt = true,
	event = "CursorMoved",
	config = conf.specs,
}
editor["tpope/vim-surround"] = { opt = true, event = "BufReadPost" }
editor["Allen191819/vim-expand-region"] = {
	opt = false,
	event = { "BufReadPost" },
	requires = {
		{ "kana/vim-textobj-user", opt = false },
		{ "sgur/vim-textobj-parameter", opt = false },
		{ "kana/vim-textobj-line", opt = false },
		{ "adolenc/vim-textobj-toplevel", opt = false },
		{ "whatyouhide/vim-textobj-xmlattr", opt = false },
	},
	config = conf.expand_region,
}
editor["alpertuna/vim-header"] = {
	opt = true,
	cmd = {
		"AddHeader",
		"AddMinHeader",
		"AddMITLicense",
		"AddApacheLicense",
		"AddGNULicense",
		"AddAGPLicense",
		"AddLGPLLicense",
		"AddMPLLicense",
		"AddWTFPLLicense",
		"AddZlibLicense",
	},
	config = conf.add_header,
}
editor["mg979/vim-visual-multi"] = { opt = true, event = { "VimEnter" }, config = conf.multi_visual }
editor["Chiel92/vim-autoformat"] = { cmd = { "Autoformat" }, opt = true }
editor["AndrewRadev/switch.vim"] = { opt = true, event = "BufRead" }
editor["abecodes/tabout.nvim"] = {
	opt = true,
	event = "InsertEnter",
	config = conf.tabout,
}
editor["yianwillis/vimcdoc"] = { opt = false }
editor["lewis6991/impatient.nvim"] = { opt = false }
editor["hkupty/iron.nvim"] = { opt = true, cmd = { "IronRepl" }, config = conf.iron }
editor["roobert/search-replace.nvim"] = { opt = true, event = { "VimEnter" }, config = conf.search_replace }
editor["Allen191819/neogen"] = { opt = true, event = "InsertEnter", branch = "fix/ts_utils", config = conf.neogen }
editor["sindrets/diffview.nvim"] = {
	opt = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
}
editor["ibhagwan/smartyank.nvim"] = {
	opt = true,
	event = "BufReadPost",
	config = conf.smartyank,
}
editor["Pocco81/true-zen.nvim"] = {
	opt = true,
	cmd = {"TZNarrow","TZFocus","TZMinimalist","TZAtaraxis"}
}

return editor
