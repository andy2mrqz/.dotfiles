local nnoremap = require("andy2mrqz.keymaps").nnoremap
local tnoremap = require("andy2mrqz.keymaps").tnoremap

-- Restore normal Y functionality
nnoremap("<S-y>", "yy")

-- Terminal keymaps
tnoremap("<esc>", "<C-\\><C-n>") -- <esc> goes to normal mode in terminal

-- Buffer navigation
nnoremap("<S-l>", ":bnext<cr>")
nnoremap("<S-h>", ":bprevious<cr>")

