local editor = {}
local conf = require("modules.editor.config")
editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }
editor["itchyny/vim-cursorword"] = {
	opt = true,
	event = { "BufReadPre", "BufNewFile" },
	config = conf.vim_cursorwod,
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
	event = { "BufRead", "BufNewFile","InsertEnter" },
	config = conf.nvim_treesitter,
}
editor["romgrk/nvim-treesitter-context"] = {
	opt = true,
	after = "nvim-treesitter",
}
editor["p00f/nvim-ts-rainbow"] = { opt = true, after = "nvim-treesitter" }
editor["JoosepAlviste/nvim-ts-context-commentstring"] = {
	opt = true,
	after = "nvim-treesitter",
}
editor["mfussenegger/nvim-ts-hint-textobject"] = {
	opt = true,
	after = "nvim-treesitter",
}
editor["SmiteshP/nvim-gps"] = {
	opt = true,
	after = "nvim-treesitter",
	config = conf.nvim_gps,
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
	cmd = { "FloatermToggle", "FloatermNew" },
	config = conf.floaterm,
}
editor["norcalli/nvim-colorizer.lua"] = {
	opt = false,
	config = conf.nvim_colorizer,
}
editor["rcarriga/nvim-dap-ui"] = {
	opt = false,
	config = conf.dap,
	requires = {
		{ "mfussenegger/nvim-dap", opt = false },
		{
			"Pocco81/dap-buddy.nvim",
			opt = false,
			commit = "24923c3819a450a772bb8f675926d530e829665f",
		},
	},
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
editor["tpope/vim-surround"] = { opt = true, event = "BufRead" }
editor["Allen191819/vim-expand-region"] = {
	opt = false,
 	event = { "VimEnter" },
	requires = {
		{ "kana/vim-textobj-user", opt = false },
		{ "sgur/vim-textobj-parameter", opt = false },
		{ "kana/vim-textobj-line", opt = false },
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
editor["mg979/vim-visual-multi"] = { opt = true,event = { "VimEnter" }, config = conf.multi_visual }
editor["Chiel92/vim-autoformat"] = { cmd = { "Autoformat" }, opt = true }
editor["AndrewRadev/switch.vim"] = { opt = true, event = "BufRead" }
editor["abecodes/tabout.nvim"] = {
	opt = true,
	config = conf.tabout,
	after = "nvim-treesitter",
}
editor["yianwillis/vimcdoc"] = { opt = false }
editor["caenrique/nvim-maximize-window-toggle"] = { opt = false }
editor["lewis6991/impatient.nvim"] = { opt = false }
editor["hkupty/iron.nvim"] = { opt = true, cmd = { "IronRepl" }, config = conf.iron }
editor["brooth/far.vim"] = { opt = true,event = { "VimEnter" }, config = conf.far_vim }
editor["Allen191819/neogen"] = { opt = true, after = "nvim-treesitter",branch="fix/ts_utils" ,config = conf.neogen }

return editor
