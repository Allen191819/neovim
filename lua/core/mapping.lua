local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

vim.api.nvim_set_keymap("n", "<Space>",     "<NOP>",                                                                           { noremap = true, silent = true})
vim.g.mapleader = " "

-- default map
local def_map = {
    -- Vim map
    ["n|<C-s>"] = map_cu("write"):with_noremap(),
    ["n|Y"] = map_cmd("y$"),
    ["n|D"] = map_cmd("d$"),
    ["n|Q"] = map_cmd(":q<Cr>"),
    ["n|W"] = map_cmd(":w<Cr>"),
    ["n|n"] = map_cmd("nzzzv"):with_noremap(),
    ["n|N"] = map_cmd("Nzzzv"):with_noremap(),
    ["n|J"] = map_cmd("mzJ`z"):with_noremap(),
    ["n|<C-h>"] = map_cmd("<C-w>h"):with_noremap(),
    ["n|<C-l>"] = map_cmd("<C-w>l"):with_noremap(),
    ["n|<C-j>"] = map_cmd("<C-w>j"):with_noremap(),
    ["n|<C-k>"] = map_cmd("<C-w>k"):with_noremap(),
    ["n|<C-c>"] = map_cmd("<C-w>c"):with_noremap(),
    ["n|<A-[>"] = map_cr("vertical resize -5"):with_silent(),
    ["n|<A-]>"] = map_cr("vertical resize +5"):with_silent(),
    ["n|<A-;>"] = map_cr("resize -2"):with_silent(),
    ["n|<A-'>"] = map_cr("resize +2"):with_silent(),
    ["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"),
    ["n|<leader>h"] = map_cr("set hlsearch!<CR>"),
    ["n|<Tab>"] = map_cr(":bnext<CR>"):with_silent(),
    ["n|<S-Tab>"] = map_cr(":bprevious<CR>"):with_silent(),
    ["n|<C-q>"] = map_cmd("<Esc>/<++><CR>:nohlsearch<CR>\"_c4l"):with_silent(),
    -- Insert
    ["i|<Cr>"] = map_cmd("<CR>x<BS>"):with_noremap(),
    ["i|<C-q>"] = map_cmd("<Esc>/<++><CR>:nohlsearch<CR>\"_c4l"):with_silent(),
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap(),
    ["i|<C-b>"] = map_cmd("<Left>"):with_noremap(),
    ["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap(),
    ["i|<C-s>"] = map_cmd("<Esc>:w<CR>"),
    -- command line
    ["c|<C-b>"] = map_cmd("<Left>"):with_noremap(),
    ["c|<C-f>"] = map_cmd("<Right>"):with_noremap(),
    ["c|<C-a>"] = map_cmd("<Home>"):with_noremap(),
    ["c|<C-e>"] = map_cmd("<End>"):with_noremap(),
    ["c|<C-d>"] = map_cmd("<Del>"):with_noremap(),
    ["c|<C-h>"] = map_cmd("<BS>"):with_noremap(),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),
    ["c|w!!"] = map_cmd(
        "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!"),
    -- Visual
    ["v|J"] = map_cmd(":m '>+1<cr>gv=gv"),
    ["v|K"] = map_cmd(":m '<-2<cr>gv=gv"),
    ["v|<"] = map_cmd("<gv"),
    ["v|>"] = map_cmd(">gv"),
	-- Toggle format
	["n|<A-f>"] = map_cr("FormatToggle"):with_noremap():with_silent(),
	-- Resize windows
    ["n|<up>"] = map_cmd(":res +5<CR>"):with_noremap():with_silent(),
    ["n|<down>"] = map_cmd(":res -5<CR>"):with_noremap():with_silent(),
    ["n|<left>"] = map_cmd(":vertical resize-5<CR>"):with_noremap():with_silent(),
    ["n|<right>"] = map_cmd(":vertical resize+5<CR>"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(def_map)
