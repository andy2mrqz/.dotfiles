local nnoremap = require("andy2mrqz.keymaps").nnoremap

-- Restore normal Y functionality
nnoremap("<S-y>", "yy")

-- Better window navigation
nnoremap("<leader>wj", "<C-w>j")
nnoremap("<leader>wk", "<C-w>k")
nnoremap("<leader>wh", "<C-w>h")
nnoremap("<leader>wl", "<C-w>l")

-- Explorer (netrw)
nnoremap("<leader>e", ":Lex 40<cr>")

-- Buffer navigation
nnoremap("<S-l>", ":bnext<cr>")
nnoremap("<S-h>", ":bprevious<cr>")
