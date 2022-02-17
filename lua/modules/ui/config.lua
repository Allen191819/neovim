local config = {}

function config.material()
    require("material").setup({
        contrast = {
            sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = true, -- Enable contrast for floating windows
            line_numbers = false, -- Enable contrast background for line numbers
            sign_column = false, -- Enable contrast background for the sign column
            cursor_line = true, -- Enable darker background for the cursor line
            non_current_windows = false, -- Enable darker background for non-current windows
            popup_menu = true -- Enable lighter background for the popup menu
        },
        italics = {
            comments = true, -- Enable italic comments
            keywords = true, -- Enable italic keywords
            functions = true, -- Enable italic functions
            strings = true, -- Enable italic strings
            variables = false -- Enable italic variables
        },
        contrast_filetypes = {
            "terminal", -- Darker terminal background
            "packer", -- Darker packer background
            "qf", -- Darker qf list background
            "undotree", "NvimTree", "dbui", "leaninfo"
        },
        high_visibility = {
            lighter = true, -- Enable higher contrast text for lighter style
            darker = true -- Enable higher contrast text for darker style
        },
        disable = {
            borders = false, -- Disable borders between verticaly split windows
            background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
            term_colors = false, -- Prevent the theme from setting terminal colors
            eob_lines = false -- Hide the end-of-buffer lines
        },
        async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
        lualine_style = "default",
        custom_highlights = {} -- Overwrite highlights with your own
    })
    vim.g.material_style = "palenight"
end

function config.edge()
    vim.cmd [[set background=dark]]
    vim.g.edge_style = "aura"
    vim.g.edge_enable_italic = 1
    vim.g.edge_disable_italic_comment = 1
    vim.g.edge_show_eob = 1
    vim.g.edge_better_performance = 1
    vim.g.edge_transparent_background = 1
end

function config.lualine()
    local gps = require("nvim-gps")
    local function gps_content()
        if gps.is_available() then
            return gps.get_location()
        else
            return ""
        end
    end
    local symbols_outline = {
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"filetype"},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {"location"}
        },
        filetypes = {"Outline"}
    }
    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand "%:t") ~= 1
        end,
        hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
        check_git_workspace = function()
            local filepath = vim.fn.expand "%:p:h"
            local gitdir = vim.fn.finddir(".git", filepath .. ";")
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end
    }

    local colors = {
        bg = "#202328",
        fg = "#bbc2cf",
        yellow = "#ECBE7B",
        cyan = "#008080",
        darkblue = "#081633",
        green = "#98be65",
        orange = "#FF8800",
        violet = "#a9a1e1",
        magenta = "#c678dd",
        blue = "#1793d1",
        red = "#ec5f67"
    }
    local conf = {
        options = {
            icons_enabled = true,
            theme = "material",
            disabled_filetypes = {},
            component_separators = "|",
            section_separators = {left = "", right = ""}
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {
                {"branch", color = {fg = colors.yellow}}, "diff", "diagnostics"
            },
            lualine_c = {
                {"filename", color = {fg = colors.magenta}}, "lsp_progress"
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {"progress", "location"}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    function()
                        return vim.api.nvim_buf_get_option(0, "filetype")
                    end,
                    icon = "%=勇"
                }
            },
            lualine_x = {"location"},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {"quickfix", "nvim-tree", "fugitive", symbols_outline}
    }
    local function ins_left(component)
        table.insert(conf.sections.lualine_c, component)
    end

    local function ins_right(component)
        table.insert(conf.sections.lualine_x, component)
    end
    ins_left {
        -- filesize component
        "filesize",
        cond = conditions.buffer_not_empty
    }

    ins_left {gps_content, cond = gps.is_available}

    ins_right {
        "o:encoding", -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = {fg = colors.violet, gui = "bold"}
    }

    ins_right {"filetype", color = {fg = colors.blue}}

    ins_right {function() return "" end, color = {fg = colors.blue}}

    ins_right {function() return "ﬦ" end, color = {fg = colors.orange}}
    ins_right {
        -- Lsp server name .
        function()
            local msg = "No Active Lsp"
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then return msg end
            msg = ""
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    msg = msg .. " " .. client.name
                end
            end
            return msg
        end,
        icon = " LSP:",
        color = {fg = colors.red, gui = "bold"}
    }

    require("lualine").setup(conf)
end

function config.nvim_tree()
    local tree_cb = require"nvim-tree.config".nvim_tree_callback
    require("nvim-tree").setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = {},
        auto_close = true,
        open_on_tab = false,
        hijack_cursor = true,
        update_cwd = false,
        update_to_buf_dir = {enable = true, auto_open = true},
        diagnostics = {
            enable = false,
            icons = {hint = "", info = "", warning = "", error = ""}
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {}
        },
        system_open = {cmd = nil, args = {}},
        filters = {dotfiles = false, custom = {}},
        git = {enable = true, ignore = true, timeout = 500},
        view = {
            width = 30,
            height = 30,
            hide_root_folder = false,
            side = "left",
            auto_resize = true,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
            mappings = {
                custom_only = true,
                list = {
                    {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
                    {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
                    {key = "<C-v>", cb = tree_cb("vsplit")},
                    {key = "<C-x>", cb = tree_cb("split")},
                    {key = "<C-t>", cb = tree_cb("tabnew")},
                    {key = "<", cb = tree_cb("prev_sibling")},
                    {key = ">", cb = tree_cb("next_sibling")},
                    {key = "P", cb = tree_cb("parent_node")},
                    {key = "<BS>", cb = tree_cb("close_node")},
                    {key = "<S-CR>", cb = tree_cb("close_node")},
                    {key = "<Tab>", cb = tree_cb("preview")},
                    {key = "K", cb = tree_cb("first_sibling")},
                    {key = "J", cb = tree_cb("last_sibling")},
                    {key = "I", cb = tree_cb("toggle_ignored")},
                    {key = "H", cb = tree_cb("toggle_dotfiles")},
                    {key = "R", cb = tree_cb("refresh")},
                    {key = "m", cb = tree_cb("create")},
                    {key = "d", cb = tree_cb("remove")},
                    {key = "a", cb = tree_cb("rename")},
                    {key = "<C-r>", cb = tree_cb("full_rename")},
                    {key = "x", cb = tree_cb("cut")},
                    {key = "yy", cb = tree_cb("copy")},
                    {key = "p", cb = tree_cb("paste")},
                    {key = "yn", cb = tree_cb("copy_name")},
                    {key = "yp", cb = tree_cb("copy_path")},
                    {key = "gy", cb = tree_cb("copy_absolute_path")},
                    {key = "[c", cb = tree_cb("prev_git_item")},
                    {key = "]c", cb = tree_cb("next_git_item")},
                    {key = "-", cb = tree_cb("dir_up")},
                    {key = "s", cb = tree_cb("system_open")},
                    {key = "q", cb = tree_cb("close")},
                    {key = "?", cb = tree_cb("toggle_help")}
                }
            }
        },
        trash = {cmd = "trash", require_confirm = true}
    }
    vim.g.nvim_tree_indent_markers = 1
end

function config.nvim_bufferline()
    require("bufferline").setup {
        options = {
            number = "none",
            modified_icon = "✥",
            buffer_close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 14,
            max_prefix_length = 13,
            tab_size = 20,
            show_buffer_close_icons = false,
            show_buffer_icons = true,
            show_tab_indicators = true,
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            separator_style = "thick",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "center",
                    padding = 1
                },
                {
                    filetype = "undotree",
                    text = "Undo History",
                    text_align = "left"
                },
                {
                    filetype = "Outline",
                    text = "Outline Window",
                    text_align = "right"
                },
                {
                    filetype = "earial",
                    text = "Outline Window",
                    text_align = "right"
                }, {filetype = "dbui", text = "Dbui", text_align = "left"},
                {filetype = "leaninfo", text = "Leaninfo", text_align = "right"}
            }
        }
    }
end

function config.gitsigns()
    require("gitsigns").setup {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "│",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn"
            },
            change = {
                hl = "GitSignsChange",
                text = "│",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                hl = "GitSignsDelete",
                text = "_",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            }
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            ["n ]g"] = {
                expr = true,
                '&diff ? \']g\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''
            },
            ["n [g"] = {
                expr = true,
                '&diff ? \'[g\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''
            },
            ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'
        },
        watch_gitdir = {interval = 1000, follow_files = true},
        current_line_blame = true,
        current_line_blame_opts = {delay = 1000, virtual_text_pos = "eol"},
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = {internal = true}
    }
end

function config.indent_blankline()
    vim.opt.termguicolors = true
    vim.opt.list = true
    require("indent_blankline").setup {
        char = "│",
        show_first_indent_level = true,
        filetype_exclude = {
            "startify", "dashboard", "dotooagenda", "log", "fugitive",
            "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
            "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
            "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
        },
        buftype_exclude = {"terminal", "nofile"},
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_current_context_start = true,
        context_patterns = {
            "class", "function", "method", "block", "list_literal", "selector",
            "^if", "^table", "if_statement", "while", "for", "type", "var",
            "import"
        },
        space_char_blankline = " "
    }
    vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
    vim.g.indentLine_concealcursor = ""
end

function config.web_icons()
    require"nvim-web-devicons".setup {
        override = {
            lean = {
                icon = "ﬦ",
                color = "#428850",
                cterm_color = "65",
                name = "lean"
            },
            v = {
                icon = "",
                color = "#428850",
                cterm_color = "65",
                name = "coq"
            },
            m = {
                icon = "",
                color = "#FF8800",
                cterm_color = "65",
                name = "coq"
            }
        },
        default = true
    }
end

return config
