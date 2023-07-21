return function()
	local util = require("lspconfig.util")
	require("coq-lsp").setup({
		lsp = {
			on_attach = function(client, bufnr)
				-- custom_attach(client);
			end,
			root_dir = util.find_git_ancestor,
			init_options = {
				show_notices_as_diagnostics = false,
				-- capabilities = capabilities,
			},
		},
	})
end
