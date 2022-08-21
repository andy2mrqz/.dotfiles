--
-- Automatically installs packer if not installed
--
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  }
  vim.cmd [[packadd packer.nvim]]
end

--
-- Autocommand to reload whenever this file is saved
--
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('PACKER', { clear = true }),
  command = 'source <afile> | PackerSync',
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

  -- cmp plugins
  use "hrsh7th/nvim-cmp"                -- completion plugin
  use "hrsh7th/cmp-buffer"              -- complete within buffer
  use "hrsh7th/cmp-path"                -- complete paths
  use "hrsh7th/cmp-cmdline"             -- completions for commandline
  use "saadparwaiz1/cmp_luasnip"        -- complete snippets

  -- snippets
  use "L3MON4D3/LuaSnip"                -- snippet engine

  use {
    "lewis6991/gitsigns.nvim",          -- Git gutter, blame, etc.
    config = function()
      require("gitsigns").setup {
        current_line_blame = false,
        current_line_blame_formatter = function(name, blame_info, opts)
          if blame_info.author == name then
            blame_info.author = 'You'
          end

          local text
          if blame_info.author == 'Not Committed Yet' then
            text = blame_info.author
          else
            local seconds_diff = os.time() - tonumber(blame_info['author_time'])
            local days_since = seconds_diff/60/60/24
            local date_time = days_since < 2 and
              require('gitsigns.util').get_relative_time(tonumber(blame_info['author_time']))
            or
              os.date('%Y-%m-%d', tonumber(blame_info['author_time']))
            text = string.format('%s, %s - %s (%s)', blame_info.author, date_time, blame_info.summary, blame_info.abbrev_sha)
          end
          return {{' '..text, 'GitSignsCurrentLineBlame'}}
        end,
        current_line_blame_opts = {
          delay = 50,
          virt_text_pos = 'eol'
        },
      }
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
