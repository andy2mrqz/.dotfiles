vim.opt.fileencoding = "utf-8"    -- set file encoding
vim.opt.number = true             -- set numbered lines
vim.opt.relativenumber = true     -- set relative numbered lines
vim.opt.tabstop = 2               -- actual tabs display as this many spaces
vim.opt.softtabstop = 2           -- tabs become spaces
vim.opt.shiftwidth = 2            -- width to shift from >> key
vim.opt.expandtab = true          -- tabs become spaces in insert mode
vim.opt.hlsearch = false          -- don't highlight all instances of a search
vim.opt.ignorecase = true         -- ignore case when searching
vim.opt.smartcase = true          -- respects case in searching if uppercase present
vim.opt.wrap = false              -- don't wrap text - autoscrolls to the side
vim.opt.smartindent = true        -- better indentation
vim.opt.autochdir = true          -- changes working directory when switching buffers
vim.opt.hidden = true             -- allow switching buffers without saving
vim.opt.undofile = true           -- persistent undo
vim.opt.signcolumn = "yes"        -- always show the signcolumn (git gutter, linting)
vim.opt.pumheight = 10
vim.opt.splitbelow = true        -- always open splits below
vim.opt.splitright = true        -- always open splits to the right

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HIGHLIGHTED_YANK", {}),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end
})

