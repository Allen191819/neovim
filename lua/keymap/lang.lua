local bind = require("keymap.bind")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local map_callback = bind.map_callback

local plug_map = {
	-- Markdown
	["n|<leader>mi"] = map_cr("PasteImg"):with_noremap():with_silent():with_desc("edit: Paste an image in markdown"),
	["n|<leader>mt"] = map_cr("TableModeToggle"):with_noremap():with_silent():with_desc("edit: Table model toogle"),
}

bind.nvim_load_mapping(plug_map)
