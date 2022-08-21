local nnoremap = require("andy2mrqz.keymaps").nnoremap
local tnoremap = require("andy2mrqz.keymaps").tnoremap

-- Restore normal Y functionality
nnoremap("<S-y>", "yy")

-- Better window navigation
nnoremap("<leader>wj", "<C-w>j")
nnoremap("<leader>wk", "<C-w>k")
nnoremap("<leader>wh", "<C-w>h")
nnoremap("<leader>wl", "<C-w>l")

-- Terminal keymaps
tnoremap("<esc>", "<C-\\><C-n>") -- <esc> goes to normal mode in terminal

-- Explorer (netrw)
nnoremap("<leader>e", ":Lex 40<cr>")

-- Buffer navigation
nnoremap("<S-l>", ":bnext<cr>")
nnoremap("<S-h>", ":bprevious<cr>")

-- gitsigns config
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")

