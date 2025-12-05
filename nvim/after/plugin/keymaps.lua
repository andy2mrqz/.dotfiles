local inoremap = require("andy2mrqz.keymaps").inoremap
local nnoremap = require("andy2mrqz.keymaps").nnoremap
local tnoremap = require("andy2mrqz.keymaps").tnoremap

-- Restore normal Y functionality
nnoremap("<S-y>", "yy")

-- Terminal keymaps
tnoremap("<esc>", "<C-\\><C-n>") -- <esc> goes to normal mode in terminal

-- Buffer navigation
nnoremap("<S-l>", ":bn<cr>")
nnoremap("<S-h>", ":bp<cr>")

nnoremap("<ScrollWheelUp>", "<C-y>")
inoremap("<ScrollWheelUp>", "<C-y>")
nnoremap("<ScrollWheelDown>", "<C-e>")
inoremap("<ScrollWheelDown>", "<C-e>")

-- Clear search highlights
nnoremap("q,", ':let @/ = ""<cr>')
