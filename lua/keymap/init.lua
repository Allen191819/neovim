local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

require("keymap.config")

local plug_map = {
	-- Bufferline
	["n|<Leader>p"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
	["n|<Leader>q"] = map_cr("BufferLinePickClose"):with_noremap():with_silent(),
	["n|<leader>be"] = map_cr("BufferLineSortByExtension"):with_noremap(),
	["n|<leader>bd"] = map_cr("BufferLineSortByDirectory"):with_noremap(),
	["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1"):with_noremap():with_silent(),
	["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2"):with_noremap():with_silent(),
	["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3"):with_noremap():with_silent(),
	["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4"):with_noremap():with_silent(),
	["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5"):with_noremap():with_silent(),
	["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6"):with_noremap():with_silent(),
	["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7"):with_noremap():with_silent(),
	["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8"):with_noremap():with_silent(),
	["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9"):with_noremap():with_silent(),
	-- Packer
	["n|<leader>ps"] = map_cr("PackerSync"):with_silent():with_noremap():with_nowait(),
	["n|<leader>pu"] = map_cr("PackerUpdate"):with_silent():with_noremap():with_nowait(),
	["n|<leader>pi"] = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait(),
	["n|<leader>pc"] = map_cr("PackerClean"):with_silent():with_noremap():with_nowait(),
	-- Lsp mapp work when insertenter and lsp start
	["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
	["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),
	["n|g["] = map_cr("<cmd>lua vim.diagnostic.goto_next()"):with_noremap():with_silent(),
	["n|g]"] = map_cr("<cmd>lua vim.diagnostic.goto_prev()"):with_noremap():with_silent(),
	["n|<leader>r"] = map_cr("Lspsaga rename"):with_noremap():with_silent(),
	["n|K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent(),
	["n|<leader>ca"] = map_cr("Lspsaga code_action"):with_noremap():with_silent(),
	["v|<leader>ca"] = map_cu("<C-U>Lspsaga range_code_action"):with_noremap():with_silent(),
	["n|gd"] = map_cr("lua vim.lsp.buf.definition()"):with_noremap():with_silent(),
	["n|gr"] = map_cr("lua vim.lsp.buf.references()"):with_noremap():with_silent(),
	["n|gh"] = map_cr("Lspsaga signature_help"):with_noremap():with_silent(),
	["n|sp"] = map_cr("Lspsaga lsp_finder"):with_noremap():with_silent(),
	["n|gp"] = map_cr("Lspsaga preview_definition"):with_noremap():with_silent(),
	-- Git
	["n|<Leader>g"] = map_cu("Git"):with_noremap():with_silent(),
	["n|gps"] = map_cr("G push"):with_noremap():with_silent(),
	["n|gpl"] = map_cr("G pull"):with_noremap():with_silent(),
	["n|Lg"] = map_cr("LazyGit"):with_noremap():with_silent(),
	-- Plugin trouble
	["n|gt"] = map_cr("TroubleToggle"):with_noremap():with_silent(),
	["n|gR"] = map_cr("TroubleToggle lsp_references"):with_noremap():with_silent(),
	["n|<leader>cd"] = map_cr("TroubleToggle document_diagnostics"):with_noremap():with_silent(),
	["n|<leader>cw"] = map_cr("TroubleToggle workspace_diagnostics"):with_noremap():with_silent(),
	["n|<leader>cq"] = map_cr("TroubleToggle quickfix"):with_noremap():with_silent(),
	["n|<leader>cl"] = map_cr("TroubleToggle loclist"):with_noremap():with_silent(),
	-- Plugin nvim-tree
	["n|<Leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
	["n|<Leader>nf"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),
	["n|<Leader>nr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent(),
	-- Undotree
	["n|<Leader>t"] = map_cr("UndotreeToggle"):with_noremap():with_silent(),
	-- Plugin Telescope
	["n|<Leader>fr"] = map_cu("Telescope frecency theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fl"] = map_cu("Telescope ultisnips theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fn"] = map_cu("Telescope notify theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fb"] = map_cu("Telescope vim_bookmarks theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fa"] = map_cu("Telescope aerial theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fw"] = map_cu("Telescope live_grep_args theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fp"] = map_cu("Telescope projects theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>ff"] = map_cu("Telescope find_files theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>sc"] = map_cu("Telescope colorscheme theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fg"] = map_cu("Telescope git_files theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fz"] = map_cu("Telescope zoxide list theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fs"] = map_cu("Telescope symbols theme=dropdown"):with_noremap():with_silent(),
	["n|<Leader>fu"] = map_cu("Telescope current_buffer_fuzzy_find theme=dropdown"):with_noremap():with_silent(),
	-- Plugin accelerate-jk
	["n|j"] = map_cmd("v:lua.enhance_jk_move('j')"):with_silent():with_expr(),
	["n|k"] = map_cmd("v:lua.enhance_jk_move('k')"):with_silent():with_expr(),
	-- Plugin vim-eft
	["n|f"] = map_cmd("v:lua.enhance_ft_move('f')"):with_expr(),
	["n|F"] = map_cmd("v:lua.enhance_ft_move('F')"):with_expr(),
	["n|t"] = map_cmd("v:lua.enhance_ft_move('t')"):with_expr(),
	["n|T"] = map_cmd("v:lua.enhance_ft_move('T')"):with_expr(),
	["n|;"] = map_cmd("v:lua.enhance_ft_move(';')"):with_expr(),
	--- Plugins vim-expand-region
	["v|v"] = map_cmd("v:lua.expand_region('v')"):with_expr(),
	["v|V"] = map_cmd("v:lua.expand_region('V')"):with_expr(),
	-- Toggle window
	["n|<leader>f"] = map_cr("ToggleOnly"):with_noremap():with_silent(),
	-- Switch
	["n|gs"] = map_cr("Switch"):with_noremap():with_silent(),
	-- Plugin Hop
	["n|<leader>w"] = map_cu("HopWord"):with_noremap(),
	["n|<leader>j"] = map_cu("HopLine"):with_noremap(),
	["n|<leader>k"] = map_cu("HopLine"):with_noremap(),
	["n|<leader>c"] = map_cu("HopChar1"):with_noremap(),
	["n|<leader>cc"] = map_cu("HopChar2"):with_noremap(),
	-- Plugin EasyAlign
	["n|ga"] = map_cmd("v:lua.enhance_align('nga')"):with_expr(),
	["x|ga"] = map_cmd("v:lua.enhance_align('xga')"):with_expr(),
	-- Plugin SymbolsOutline
	["n|<leader>b"] = map_cr("AerialToggle"):with_noremap():with_silent(),
	-- Plugin split-term
	["n|<F12>"] = map_cr("FloatermToggle"):with_noremap():with_silent(),
	["n|<leader>th"] = map_cr("Term"):with_noremap():with_silent(),
	["n|<leader>tv"] = map_cr("VTerm"):with_noremap():with_silent(),
	-- QuickRun
	["n|<A-e>"] = map_cr("QuickRun"):with_noremap():with_silent(),
	-- Plugin SnipRun
	["v|<A-r>"] = map_cr("'<,'>SnipRun"):with_noremap():with_silent(),
	["n|<A-c>"] = map_cr("SnipClose"):with_noremap():with_silent(),
	-- Markdown
	["n|<leader>mi"] = map_cr("PasteImg"):with_noremap():with_silent(),
	["n|<leader>mt"] = map_cr("TableModeToggle"):with_noremap():with_silent(),
	-- Plugin dap
	["n|<F6>"] = map_cr("lua require('dap').continue()"):with_noremap():with_silent(),
	["n|<leader>dr"] = map_cr("lua require('dap').continue()"):with_noremap():with_silent(),
	["n|<leader>dd"] = map_cr("lua require('dap').terminate() require('dapui').close()"):with_noremap():with_silent(),
	["n|<leader>db"] = map_cr("lua require('dap').toggle_breakpoint()"):with_noremap():with_silent(),
	["n|<leader>dB"] = map_cr("lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))")
		:with_noremap()
		:with_silent(),
	["n|<leader>dbl"] = map_cr("lua require('dap').list_breakpoints()"):with_noremap():with_silent(),
	["n|<leader>drc"] = map_cr("lua require('dap').run_to_cursor()"):with_noremap():with_silent(),
	["n|<leader>drl"] = map_cr("lua require('dap').run_last()"):with_noremap():with_silent(),
	["n|<F7>"] = map_cr("lua require('dap').step_over()"):with_noremap():with_silent(),
	["n|<leader>dv"] = map_cr("lua require('dap').step_over()"):with_noremap():with_silent(),
	["n|<F8>"] = map_cr("lua require('dap').step_into()"):with_noremap():with_silent(),
	["n|<leader>di"] = map_cr("lua require('dap').step_into()"):with_noremap():with_silent(),
	["n|<F9>"] = map_cr("lua require('dap').step_out()"):with_noremap():with_silent(),
	["n|<leader>do"] = map_cr("lua require('dap').step_out()"):with_noremap():with_silent(),
	["n|<leader>dl"] = map_cr("lua require('dap').repl.open()"):with_noremap():with_silent(),
	["o|m"] = map_cu([[lua require('tsht').nodes()]]):with_silent(),
	-- IronRepl
	["v|<leader>is"] = map_cmd("<Plug>(iron-visual-send)"):with_silent(),
	["n|<leader>ir"] = map_cr("IronRepl"):with_silent(),
	-- Neogen
	["n|gnf"] = map_cr("Neogen func"):with_noremap():with_silent(),
	["n|gnc"] = map_cr("Neogen class"):with_noremap():with_silent(),
	["n|gnt"] = map_cr("Neogen type"):with_noremap():with_silent(),
	["n|gnl"] = map_cr("Neogen file"):with_noremap():with_silent(),
	-- Calender
	["n|,uu"] = map_cr("Calendar"):with_noremap():with_silent(),
	["n|,uc"] = map_cr("Calendar -view=clock"):with_noremap():with_silent(),
	["n|,uy"] = map_cr("Calendar -view=year -split=vertical -width=27"):with_noremap():with_silent(),
	-- Bookmark
	["n|mm"] = map_cr("BookmarkToggle"):with_noremap():with_silent(),
	["n|mn"] = map_cr("BookmarkNext"):with_noremap():with_silent(),
	["n|mp"] = map_cr("BookmarkPrev"):with_noremap():with_silent(),
	["n|ma"] = map_cr("BookmarkShowAll"):with_noremap():with_silent(),
	["n|mx"] = map_cr("BookmarkClear"):with_noremap():with_silent(),
	-- Neorg
	["n|<leader>sn"] = map_cr("Neorg gtd"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(plug_map)
