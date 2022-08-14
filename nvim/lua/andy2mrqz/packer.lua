-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use "rebelot/kanagawa.nvim"

  -- Git gutter, blame, etc.
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Plug 'tomasiser/vim-code-dark'
  -- Plug 'tpope/vim-surround'
  -- Plug 'machakann/vim-highlightedyank'
  -- Plug 'lewis6991/gitsigns.nvim' " Migrate to packer
end)
