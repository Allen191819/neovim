local completion = {}
local conf = require("modules.completion.config")
completion["neovim/nvim-lspconfig"] = {
    opt = true,
    event = {"BufReadPre","BufNewFile","BufRead"},
    config = conf.nvim_lsp
}
--[[completion["creativenull/efmls-configs-nvim"] = {
    opt = false,
    requires = "neovim/nvim-lspconfig"
}]]
completion["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}
completion["RishabhRD/nvim-lsputils"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.nvim_lsputils
}
completion["kosayoda/nvim-lightbulb"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.lightbulb
}
completion["onsails/lspkind-nvim"] = {
    opt = false,
    config = conf.lspkind
}
completion["ray-x/lsp_signature.nvim"] = {opt = true, after = "nvim-lspconfig"}
completion["hrsh7th/nvim-cmp"] = {
    config = conf.cmp,
    requires = {
        {"lukas-reineke/cmp-under-comparator"},
        {"quangnguyen30192/cmp-nvim-ultisnips"},
        {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"hrsh7th/cmp-path", after = "cmp-nvim-lua"},
        {"hrsh7th/cmp-buffer", after = "cmp-path"},
        {"hrsh7th/cmp-calc", after = "cmp-path"},
        {"hrsh7th/cmp-cmdline", after = "cmp-buffer"},
        {"ray-x/cmp-treesitter", after = "cmp-buffer"},
        {"kdheepak/cmp-latex-symbols",ft={"tex"}},
        {"kristijanhusak/vim-dadbod-completion", ft = {"sql", "mysql"}},
		{"hrsh7th/cmp-copilot",after = "copilot.vim"},
        {
            "tzachar/cmp-tabnine",
            run = "./install.sh",
            after = "nvim-cmp",
            config = conf.tabnine
        }
    }
}

completion["SirVer/ultisnips"] = {
    after = "nvim-cmp",
    config = conf.ultisnips,
    requires = "Allen191819/vim-snippets"
}

completion["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = conf.autopairs
}
completion["github/copilot.vim"] = {opt = true, cmd = "Copilot"}
return completion
