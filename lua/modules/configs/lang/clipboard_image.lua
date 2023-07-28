return function()
	require("clipboard-image").setup({
		default = {
			img_dir = { "%:p:h", "img", "%:t:r" },
			affix = "![](%s)",
			img_name = function()
				vim.fn.inputsave()
				local name = vim.fn.input("Name: ")
				vim.fn.inputrestore()
				if name == nil or name == "" then
					return os.date("%y-%m-%d-%H-%M-%S")
				end
				return name
			end,
		},
		markdown = { affix = "![](%s)" },
		tex = { affix = "{%s}" },
	})
end
