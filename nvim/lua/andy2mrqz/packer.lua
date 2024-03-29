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
  use("tpope/vim-fugitive") -- Git in neovim!
  use("github/copilot.vim") -- Github Copilot in neovim!
	use("nvim-treesitter/nvim-treesitter", {
		run = ":TSUpdate", -- Treesitter for better highlighting/language support
	})
	use("numToStr/Comment.nvim") -- Commenting functionality
	use("JoosepALviste/nvim-ts-context-commentstring") -- Context aware commenting (jsx)
	use("folke/which-key.nvim") -- show command options as you type
	use({
		"karb94/neoscroll.nvim", -- smooth scrolling
		config = function()
			require("neoscroll").setup()
		end,
		commit = "54c5c419f6ee2b35557b3a6a7d631724234ba97a",
	})
	use({
		"akinsho/toggleterm.nvim", -- better terminal support
		tag = "*",
	})

	use({
		"goolord/alpha-nvim", -- Startup theme
		requires = { "kyazdani42/nvim-web-devicons" }
	})

	use({
		"kyazdani42/nvim-tree.lua", -- File tree
		requires = { "kyazdani42/nvim-web-devicons" },
		tag = "nightly",
	})

	-- lsp plugins (ORDER MATTERS)
	use({
		"williamboman/mason.nvim", -- lsp/linter package manager
		"williamboman/mason-lspconfig.nvim", -- bridges mason and lspconfig
		"neovim/nvim-lspconfig", -- nvim builtin lsp
		"jose-elias-alvarez/null-ls.nvim", -- for formatters/linters
    'simrat39/rust-tools.nvim', -- rust tools for better rust-analyzer and inlay hints
	})

	use({ "Olical/conjure", ft = { "clojure" } }) -- repl support for clojure/other languages
	use({ "vlime/vlime", ft = { "lisp" } }) -- support for common lisp

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-nvim-lsp") -- complete lsp suggestions
	use("hrsh7th/cmp-nvim-lsp-signature-help") -- show function signature while typing
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
	use("windwp/nvim-ts-autotag") -- Autoclose html tags
	use("lukas-reineke/indent-blankline.nvim") -- indent guides
	use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }) -- :Bd doesn't mess up splits

	if PACKER_BOOTSTRAP then -- Runs the first time when bootstrapping
		require("packer").sync()
	end
end)
