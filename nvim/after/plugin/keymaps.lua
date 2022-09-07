local nnoremap = require("andy2mrqz.keymaps").nnoremap
local tnoremap = require("andy2mrqz.keymaps").tnoremap

-- Restore normal Y functionality
nnoremap("<S-y>", "yy")

-- Better window navigation
nnoremap("<leader>wj", "<C-w>j")
nnoremap("<leader>wk", "<C-w>k")
nnoremap("<leader>wh", "<C-w>h")
nnoremap("<leader>wl", "<C-w>l")
nnoremap("<leader>wq", ":bd<cr>")

-- Terminal keymaps
tnoremap("<esc>", "<C-\\><C-n>") -- <esc> goes to normal mode in terminal

-- Explorer (netrw)
nnoremap("<leader>e", ":Lex 40<cr>")

-- Buffer navigation
nnoremap("<S-l>", ":bnext<cr>")
nnoremap("<S-h>", ":bprevious<cr>")

-- gitsigns config
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")

-- telescope shortcuts
local function find_git_or_files()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root ~= "" then
    require("telescope.builtin").git_files()
  else
    require("telescope.builtin").find_files()
  end
end

nnoremap("<leader>ff", find_git_or_files)
nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")
