local config = {}

function config.nvim_lsp()
    require("modules.completion.lsp")
end

function config.lightbulb()
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
end
function config.lspkind()
    local lspkind = require("lspkind")
    lspkind.init(
        {
            with_text = true,
            preset = "codicons",
            symbol_map = {
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "ﰠ",
                Variable = "",
                Class = "ﴯ",
                Interface = "",
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
                TypeParameter = ""
            }
        }
    )
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

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local types = require("cmp.types")
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local source_menu = {
        cmp_tabnine = "[TN]",
        buffer = "[BUF]",
        orgmode = "[ORG]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[PATH]",
        tmux = "[TMUX]",
        luasnip = "[SNIP]",
        spell = "[SPELL]",
        treesitter = "[TS]",
        emoji = "[Emoji]",
        calc = "[Calc]",
        vim_dadbod_completion = "[DB]",
        latex_symbols = "[Latex]",
        cmdline = "[Cmd]"
    }
    cmp.setup {
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require("cmp-under-comparator").under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order
            }
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]
                local menu = source_menu[entry.source.name]
                if entry.source.name == "cmp_tabnine" then
                    if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                        menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                end
                vim_item.menu = menu
                return vim_item
            end
        },
        mapping = {
            ["<CR>"] = cmp.mapping.confirm({select = true}),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            ),
            ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            )
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        sources = {
            {name = "nvim_lsp"},
            {name = "nvim_lua"},
            {name = "luasnip"},
            {name = "path"},
            {name = "spell"},
            {name = "calc"},
            {name = "treesitter"},
            {name = "buffer"},
            {name = "latex_symbols"},
            {name = "vim_dadbod_completion"},
            {name = "cmp_tabnine"}
        },
        experimental = {
            native_menu = false,
            ghost_text = true
        },
        preselect = types.cmp.PreselectMode.Item,
        completion = {
            autocomplete = {
                types.cmp.TriggerEvent.TextChanged
            },
            completeopt = "menu,menuone,noselect",
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
            keyword_length = 2,
            get_trigger_characters = function(trigger_characters)
                return trigger_characters
            end
        }
    }
    cmp.setup.cmdline(
        ":",
        {
            sources = cmp.config.sources(
                {
                    {name = "path"}
                },
                {
                    {name = "cmdline"}
                }
            )
        }
    )
    cmp.setup.cmdline(
        "/",
        {
            sources = {
                {name = "buffer"}
            }
        }
    )
end

function config.luasnip()
    require("luasnip").config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI"
    }
    require("luasnip/loaders/from_vscode").load()
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
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
    cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
end

function config.nvim_lsputils()
    if vim.fn.has("nvim-0.5.1") == 1 then
        vim.lsp.handlers["textDocument/codeAction"] = require "lsputil.codeAction".code_action_handler
        vim.lsp.handlers["textDocument/references"] = require "lsputil.locations".references_handler
        vim.lsp.handlers["textDocument/definition"] = require "lsputil.locations".definition_handler
        vim.lsp.handlers["textDocument/declaration"] = require "lsputil.locations".declaration_handler
        vim.lsp.handlers["textDocument/typeDefinition"] = require "lsputil.locations".typeDefinition_handler
        vim.lsp.handlers["textDocument/implementation"] = require "lsputil.locations".implementation_handler
        vim.lsp.handlers["textDocument/documentSymbol"] = require "lsputil.symbols".document_handler
        vim.lsp.handlers["workspace/symbol"] = require "lsputil.symbols".workspace_handler
    else
        local bufnr = vim.api.nvim_buf_get_number(0)

        vim.lsp.handlers["textDocument/codeAction"] = function(_, _, actions)
            require("lsputil.codeAction").code_action_handler(nil, actions, nil, nil, nil)
        end

        vim.lsp.handlers["textDocument/references"] = function(_, _, result)
            require("lsputil.locations").references_handler(
                nil,
                result,
                {
                    bufnr = bufnr
                },
                nil
            )
        end

        vim.lsp.handlers["textDocument/definition"] = function(_, method, result)
            require("lsputil.locations").definition_handler(
                nil,
                result,
                {
                    bufnr = bufnr,
                    method = method
                },
                nil
            )
        end

        vim.lsp.handlers["textDocument/declaration"] = function(_, method, result)
            require("lsputil.locations").declaration_handler(
                nil,
                result,
                {
                    bufnr = bufnr,
                    method = method
                },
                nil
            )
        end

        vim.lsp.handlers["textDocument/typeDefinition"] = function(_, method, result)
            require("lsputil.locations").typeDefinition_handler(
                nil,
                result,
                {
                    bufnr = bufnr,
                    method = method
                },
                nil
            )
        end

        vim.lsp.handlers["textDocument/implementation"] = function(_, method, result)
            require("lsputil.locations").implementation_handler(
                nil,
                result,
                {
                    bufnr = bufnr,
                    method = method
                },
                nil
            )
        end

        vim.lsp.handlers["textDocument/documentSymbol"] = function(_, _, result, _, bufn)
            require("lsputil.symbols").document_handler(nil, result, {bufnr = bufn}, nil)
        end

        vim.lsp.handlers["textDocument/symbol"] = function(_, _, result, _, bufn)
            require("lsputil.symbols").workspace_handler(nil, result, {bufnr = bufn}, nil)
        end
    end
end

return config
