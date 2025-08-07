require("kanagawa").setup({
	overrides = function(_colors)
		return {
			Search = { bg = "NvimDarkYellow" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")
