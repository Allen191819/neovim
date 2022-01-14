local config = {}

function config.rust_tools()
    local opts = {
        tools = {
            -- rust-tools options
            -- Automatically set inlay hints (type hints)
            autoSetHints = true,
            -- Whether to show hover actions inside the hover window
            -- This overrides the default hover handler
            hover_with_actions = true,
            runnables = {
                -- whether to use telescope for selection menu or not
                use_telescope = true

                -- rest of the opts are forwarded to telescope
            },
            debuggables = {
                -- whether to use telescope for selection menu or not
                use_telescope = true

                -- rest of the opts are forwarded to telescope
            },
            -- These apply to the default RustSetInlayHints command
            inlay_hints = {
                -- Only show inlay hints for the current line
                only_current_line = false,
                -- Event which triggers a refersh of the inlay hints.
                -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                -- not that this may cause  higher CPU usage.
                -- This option is only respected when only_current_line and
                -- autoSetHints both are true.
                only_current_line_autocmd = "CursorHold",
                -- wheter to show parameter hints with the inlay hints or not
                show_parameter_hints = true,
                -- prefix for parameter hints
                parameter_hints_prefix = "<- ",
                -- prefix for all the other hints (type, chaining)
                other_hints_prefix = " » ",
                -- whether to align to the length of the longest line in the file
                max_len_align = false,
                -- padding from the left if max_len_align is true
                max_len_align_padding = 1,
                -- whether to align to the extreme right or not
                right_align = false,
                -- padding from the right if right_align is true
                right_align_padding = 7
            },
            hover_actions = {
                -- the border that is used for the hover window
                -- see vim.api.nvim_open_win()
                border = {
                    {"╭", "FloatBorder"},
                    {"─", "FloatBorder"},
                    {"╮", "FloatBorder"},
                    {"│", "FloatBorder"},
                    {"╯", "FloatBorder"},
                    {"─", "FloatBorder"},
                    {"╰", "FloatBorder"},
                    {"│", "FloatBorder"}
                },
                -- whether the hover action window gets automatically focused
                auto_focus = false
            }
        },
        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {} -- rust-analyer options
    }

    require("rust-tools").setup(opts)
end

function config.lang_go()
    vim.g.go_doc_keywordprg_enabled = false
end

function config.makrkdown_preview()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_command_for_global = 0
    vim.g.mkdp_browser = "surf"
    vim.g.mkdp_highlight_css = ""
    vim.g.mkdp_page_title = "「${name}」"
    vim.g.mkdp_filetypes = {"markdown"}
    vim.g.mkdp_preview_options = {hide_yaml_meta = 1, disable_filename = 1, theme = "light"}
    vim.g.mkdp_markdown_css = "/home/allen/.config/nvim/color/markdown.css"

    vim.g.vmt_auto_update_on_save = 1
    vim.cmd([[
    source ~/.config/nvim/md-snippets.vim
    autocmd BufRead,BufNewFile *.md setlocal spell
]])
end

function config.clipboard_image()
    require "clipboard-image".setup {
        default = {
            img_dir = "img",
            img_dir_txt = "img",
            img_name = function()
                return os.date("%Y-%m-%d-%H-%M-%S")
            end,
            affix = "%s"
        },
        markdown = {
            affix = "![](%s)"
        }
    }
end

function config.latex()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_quickfix_mode = 0
    vim.g.tex_flavor = "latex"
    vim.g.conceallevel = 2
    vim.g.tex_conceal = "abdmg"
    vim.g.vimtex_compliler_progname = "nvr"
    vim.g.vimtex_mappings_enabled = 0
    vim.g.vimtex_text_obj_enabled = 0
    vim.g.vimtex_motion_enabled = 0
    vim.g.vimtex_syntax_conceal = {
        accents = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 1,
        styles = 1
    }
end

return config
