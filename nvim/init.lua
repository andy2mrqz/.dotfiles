require("andy2mrqz")

-- From ":help nvim-tree-api"
-- It is strongly advised to eagerly disable netrw, due to race conditions at vim
-- startup. Set the following at the very beginning of your init.lua

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Map leader to <Space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable Matchit for performance reasons (and I don't use it)
vim.cmd("MatchDisable")
