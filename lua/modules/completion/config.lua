local config = {}
function config.nvim_lsp() require("modules.completion.lsp") end

function config.lightbulb()
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb{ float = { enabled = true, text = "💡", win_opts = {}, }, virtual_text = { enabled = true, text = "💡", hl_mode = "replace", }, status_text = { enabled = false, text = "💡", text_unavailable = "" } }]]
end

function config.lspkind()
    local lspkind = require("lspkind")
    lspkind.init({
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "𝓒",
            Interface = "ﰮ",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = "𝙏"
        }
    })
end

function config.cmp()
    vim.cmd [[highlight CmpItemAbbrDeprecated guifg=#D8DEE9 guibg=NONE gui=strikethrough]]
    vim.cmd [[highlight CmpItemKindSnippet guifg=#BF616A guibg=NONE]]
    vim.cmd [[highlight CmpItemKindUnit guifg=#D08770 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindProperty guifg=#A3BE8C guibg=NONE]]
    vim.cmd [[highlight CmpItemKindKeyword guifg=#EBCB8B guibg=NONE]]
    vim.cmd [[highlight CmpItemAbbrMatch guifg=#5E81AC guibg=NONE]]
    vim.cmd [[highlight CmpItemAbbrMatchFuzzy guifg=#5E81AC guibg=NONE]]
    vim.cmd [[highlight CmpItemKindVariable guifg=#8FBCBB guibg=NONE]]
    vim.cmd [[highlight CmpItemKindInterface guifg=#88C0D0 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindText guifg=#81A1C1 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindFunction guifg=#B48EAD guibg=NONE]]
    vim.cmd [[highlight CmpItemKindMethod guifg=#B48EAD guibg=NONE]]

    require("cmp_nvim_ultisnips").setup {show_snippets = "all"}
    local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
    local types = require("cmp.types")
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local source_menu = {
        cmp_tabnine = "[TN]",
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[PATH]",
        tmux = "[TMUX]",
        ultisnips = "[SNIP]",
        spell = "[SPELL]",
        emoji = "[Emoji]",
        calc = "[Calc]",
        vim_dadbod_completion = "[DB]",
        latex_symbols = "[Latex]",
        copilot = "[AI]",
        orgmode = "[Org]"
    }
    cmp.setup {
        sorting = {
            comparators = {
                cmp.config.compare.offset, cmp.config.compare.exact,
                cmp.config.compare.score, require("cmp-under-comparator").under,
                cmp.config.compare.kind, cmp.config.compare.sort_text,
                cmp.config.compare.length, cmp.config.compare.order
            }
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]
                local menu = source_menu[entry.source.name]
                if entry.source.name == "cmp_tabnine" then
                    if entry.completion_item.data ~= nil and
                        entry.completion_item.data.detail ~= nil then
                        menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                end
                if entry.source.name == "copilot" then
                    if entry.completion_item.data ~= nil and
                        entry.completion_item.data.detail ~= nil then
                        menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                end
                if entry.source.name == "orgmode" then
                    if entry.completion_item.data ~= nil and
                        entry.completion_item.data.detail ~= nil then
                        menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                end
                vim_item.menu = menu
                return vim_item
            end
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({select = true}),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
            ["<Tab>"] = cmp.mapping(function(fallback)
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            end, {"i", "s", "c"}),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end, {"i", "s", "c"})
        },
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end
        },
        sources = {
            {name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "ultisnips"},
            {name = "path"}, {name = "calc"}, {name = "buffer"},
            {name = "latex_symbols"}, {name = "vim_dadbod_completion"},
            {name = "cmp_tabnine"}, -- {name = "copilot"},
            {name = "nvim_lsp_signature_help"}, {name = 'orgmode'},
            {name = "emoji"}
        },
        experimental = {native_menu = false, ghost_text = false},
        preselect = types.cmp.PreselectMode.Item,
        completion = {
            autocomplete = {types.cmp.TriggerEvent.TextChanged},
            completeopt = "menu,menuone,noselect",
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
            keyword_length = 2,
            get_trigger_characters = function(trigger_characters)
                return trigger_characters
            end
        }
    }
end

function config.ultisnips()
    vim.api.nvim_exec([[
	autocmd BufWritePost *.snippets :CmpUltisnipsReloadSnippets
	]], true)
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsEditSplit = "vertical"
    vim.cmd [[
	let g:UltiSnipsSnippetDirectories=[$HOME."/.config/nvim/ultsnips"]
	]]
end

function config.tabnine()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({max_line = 200, max_num_results = 20, sort = true})
end
function config.autopairs()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    npairs.setup()
    npairs.add_rule(Rule("$$", "$$", "tex"))
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done",
                 cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
    cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
end

function config.copilot()
    vim.cmd [[ imap <silent><script><expr> <A-h> copilot#Accept("\<CR>") ]]
    vim.cmd [[ let g:copilot_no_tab_map = v:true ]]
    vim.cmd [[ highlight CopilotSuggestion guifg=#555FFF ctermfg=8 ]]
end

function config.lean()
    vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
    vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
    local function custom_attach(client)
        require("lsp_signature").on_attach({
            bind = true,
            use_lspsaga = false,
            floating_window = true,
            fix_pos = true,
            hint_enable = true,
            hi_parameter = "Search",
            handler_opts = {"double"}
        })

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                                                                  vim.lsp
                                                                      .diagnostic
                                                                      .on_publish_diagnostics,
                                                                  {
                signs = false,
                underline = false,
                virtual_text = {spacing = 15, prefix = ''},
                update_in_insert = true
            })

        if client.resolved_capabilities.document_formatting then
            vim.cmd [[augroup Format]]
            vim.cmd [[autocmd! * <buffer>]]
            vim.cmd [[autocmd BufWritePost <buffer> lua require'modules.completion.formatting'.format()]]
            vim.cmd [[augroup END]]
        end
    end
    require("lean").setup {
        abbreviations = {builtin = true, extra = {wknight = "♘"}},
        lsp = {on_attach = custom_attach},
        lsp3 = {on_attach = custom_attach},
        mappings = true,
        infoview = {
            autoopen = true,
            width = 40,
            height = 20,
            indicators = "always"
        },
        progress_bars = {enable = true, priority = 10},
        stderr = {enable = true}
    }
end

function config.renamer()
    require("renamer").setup {
        border = true,
        border_chars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        show_refs = true,
        with_qf_list = true,
        with_popup = true
    }
end

return config
