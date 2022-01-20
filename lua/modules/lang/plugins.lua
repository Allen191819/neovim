local lang = {}
local conf = require("modules.lang.config")

lang['fatih/vim-go'] = {
    opt = true,
    ft = 'go',
    run = ':GoInstallBinaries',
    config = conf.lang_go
}
lang["rust-lang/rust.vim"] = {opt = true, ft = "rust"}
lang["simrat39/rust-tools.nvim"] = {
    opt = true,
    ft = "rust",
    config = conf.rust_tools,
    requires = {{"nvim-lua/plenary.nvim", opt = false}}
}
lang["yaocccc/markdown-preview.nvim"] = {
    opt = true,
    ft = "markdown",
    run = "cd app && yarn install",
    config=conf.makrkdown_preview
}
lang["chrisbra/csv.vim"] = {opt = true, ft = "csv"}
lang["lervag/vimtex"] = {opt=true,ft='tex',config=conf.latex}
lang["dhruvasagar/vim-table-mode"] = {opt=true,ft='markdown'}
lang["mzlogin/vim-markdown-toc"] = {opt=true,ft='markdown'}
lang["ekickx/clipboard-image.nvim"] = {opt=true,commit='f678fb378c049cd3f6b0a187014e9bc3bbd09706',cmd={'PasteImg'},ft='markdown',config=conf.clipboard_image}
lang['h-hg/fcitx.nvim'] = {opt=false,event="VimEnter"}
return lang
