--
-- Automatically installs packer if not installed
--
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.cmd([[packadd packer.nvim]])
end

--
-- Autocommand to reload whenever this file is saved
--
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
	command = "source <afile> | PackerSync",
	pattern = "packer.lua",
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Open packer in a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Plugins to install
return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Packer can manage itself
	use("nvim-lua/plenary.nvim") -- Common dependency fns
	use("lewis6991/impatient.nvim") -- Speeds up lua module loading for better startup time
	use("rebelot/kanagawa.nvim") -- Colorscheme
	use("nvim-treesitter/nvim-treesitter", {
		run = ":TSUpdate", -- Treesitter for better highlighting/language support
	})
	use("numToStr/Comment.nvim") -- Commenting functionality
	use("JoosepALviste/nvim-ts-context-commentstring") -- Context aware commenting (jsx)

	-- lsp plugins (ORDER MATTERS)
	use({
		"williamboman/mason.nvim", -- lsp/linter package manager
		"williamboman/mason-lspconfig.nvim", -- bridges mason and lspconfig
		"neovim/nvim-lspconfig", -- nvim builtin lsp
		"jose-elias-alvarez/null-ls.nvim", -- for formatters/linters
	})

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-nvim-lsp") -- complete lsp suggestions
	use("hrsh7th/cmp-nvim-lua") -- completion for nvim lua
	use("hrsh7th/cmp-buffer") -- complete within buffer
	use("hrsh7th/cmp-path") -- complete paths
	use("hrsh7th/cmp-cmdline") -- completions for commandline
	use("saadparwaiz1/cmp_luasnip") -- complete snippets

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine

	-- telescope
	use("nvim-telescope/telescope.nvim") -- fuzzy finding searcher

	-- miscellaneous
	use("lewis6991/gitsigns.nvim") -- Git gutter, blame, etc.
	use({
		"kylechui/nvim-surround", -- Easier surrounding (e.g. cs"')
		config = function()
			require("nvim-surround").setup()
		end,
	})
	use("windwp/nvim-autopairs") -- Autoclose " ' ( {

	if PACKER_BOOTSTRAP then -- Runs the first time when bootstrapping
		require("packer").sync()
	end
end)
