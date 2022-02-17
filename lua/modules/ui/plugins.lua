local ui = {}
local conf = require("modules.ui.config")

ui["kyazdani42/nvim-web-devicons"] = {opt = false, config = conf.web_icons}
ui["sainnhe/edge"] = {opt = false, config = conf.edge}
ui["hoob3rt/lualine.nvim"] = {
    opt = true,
    after = "nvim-gps",
    config = conf.lualine
}
ui["arkav/lualine-lsp-progress"] = {opt = true, after = "nvim-lspconfig"}
ui["glepnir/dashboard-nvim"] = {opt = true, event = "BufWinEnter"}
ui["kyazdani42/nvim-tree.lua"] = {
    opt = true,
    cmd = {"NvimTreeToggle", "NvimTreeOpen"},
    config = conf.nvim_tree
}
ui["lewis6991/gitsigns.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = conf.gitsigns,
    requires = {"nvim-lua/plenary.nvim", opt = true}
}
ui["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    event = "BufRead",
    config = conf.indent_blankline
}
ui["akinsho/nvim-bufferline.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.nvim_bufferline
}
ui["marko-cerovac/material.nvim"] = {opt = false, config = conf.material}

return ui
