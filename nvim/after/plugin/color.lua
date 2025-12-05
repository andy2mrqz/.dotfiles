require("kanagawa").setup({
	overrides = function(_colors)
		return {
			Search = { bg = "NvimDarkYellow" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

vim.opt.colorcolumn = "80,120" -- set rulers for lines
