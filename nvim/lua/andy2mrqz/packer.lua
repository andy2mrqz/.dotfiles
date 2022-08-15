--
-- Automatically installs packer if not installed
--
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system(
    "git clone --depth 1 https://github.com/wbthomason/packer.nvim" .. install_path
  )
  vim.cmd [[packadd packer.nvim]]
end

--
-- Autocommand to reload whenever this file is saved
--
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('PACKER', { clear = true }),
  command = 'source <afile> | PackerCompile',
  pattern = 'packer.lua'
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Open packer in a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end
  }
}

-- Plugins to install
return packer.startup(function(use)
  use "wbthomason/packer.nvim"          -- Packer can manage itself
  use "lewis6991/impatient.nvim"        -- Speeds up lua module loading for better startup time
  use "rebelot/kanagawa.nvim"           -- Colorscheme
  use {
    "nvim-treesitter/nvim-treesitter",  -- Treesitter for better highlighting/language support
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }
  use {
    "lewis6991/gitsigns.nvim",          -- Git gutter, blame, etc.
    config = function()
      require("gitsigns").setup()
    end
  }                                     
  use {
    "kylechui/nvim-surround",           -- Easier surrounding (e.g. cs"')
    config = function()
      require("nvim-surround").setup()
    end
  }

  if PACKER_BOOTSTRAP then              -- Runs the first time when bootstrapping
    require("packer").sync()
  end
end)