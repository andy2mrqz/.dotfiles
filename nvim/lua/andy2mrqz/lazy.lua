--
-- Automatically installs lazy.nvim if not installed
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- Plugins to install
lazy.setup({
	"nvim-lua/plenary.nvim", -- Common dependency fns
	"lewis6991/impatient.nvim", -- Speeds up lua module loading for better startup time
	"rebelot/kanagawa.nvim", -- Colorscheme
	"tpope/vim-fugitive", -- Git in neovim!
	{
		"github/copilot.vim", -- Github Copilot in neovim!
		-- cmd = "Copilot",
	},
	{
		"nvim-treesitter/nvim-treesitter", -- Treesitter for better highlighting/language support
		build = ":TSUpdate",
	},
	"folke/which-key.nvim", -- show command options as you type
	"akinsho/toggleterm.nvim", -- better terminal support
	{
		"karb94/neoscroll.nvim", -- smooth scrolling
		config = function()
			require("neoscroll").setup()
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},
	{
		"kyazdani42/nvim-tree.lua", -- File tree
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},
	{
		"williamboman/mason.nvim", -- lsp/linter package manager
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- bridges mason and lspconfig
			"neovim/nvim-lspconfig", -- nvim builtin lsp
			"simrat39/rust-tools.nvim", -- rust tools for better rust-analyzer and inlay hints
		},
	},
	{
		"nvimtools/none-ls.nvim", -- for formatters/linters
		dependencies = {
			"gbprod/none-ls-shellcheck.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
	},
	{
		-- cmp plugins
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- complete lsp suggestions
			"hrsh7th/cmp-nvim-lsp-signature-help", -- show function signature while typing
			"hrsh7th/cmp-nvim-lua", -- completion for nvim lua
			"hrsh7th/cmp-buffer", -- complete within buffer
			"hrsh7th/cmp-path", -- complete paths
			"hrsh7th/cmp-cmdline", -- completions for commandline
			"saadparwaiz1/cmp_luasnip", -- complete snippets
		},
	},
	"nvim-telescope/telescope.nvim", -- fuzzy finding searcher
	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"lewis6991/gitsigns.nvim", -- Git gutter, blame, etc.
	{
		"kylechui/nvim-surround", -- Easier surrounding (e.g. cs"')
		config = function()
			require("nvim-surround").setup()
		end,
	},
	"windwp/nvim-autopairs", -- Autoclose " ' ( {
	"windwp/nvim-ts-autotag", -- Autoclose html tags
	"lukas-reineke/indent-blankline.nvim", -- indent guides
	"moll/vim-bbye", -- :Bd doesn't mess up splits
	{
		"numToStr/Comment.nvim", -- Commenting functionality
		dependencies = {
			"JoosepALviste/nvim-ts-context-commentstring", -- Context aware commenting (jsx)
		},
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
		lazy = false,
	},
})
