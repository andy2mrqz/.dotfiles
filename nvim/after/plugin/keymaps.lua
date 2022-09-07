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
local themes = require("telescope.themes")

local function maybe_git_root() -- nil or string
  return vim.fn.systemlist("git rev-parse --show-toplevel 2> /dev/null")[1]
end

local function custom_find_files()
  if maybe_git_root() ~= nil then
    require("telescope.builtin").git_files(themes.get_dropdown {
      show_untracked = true,
    })
  else
    require("telescope.builtin").find_files(themes.get_dropdown())
  end
end

local function custom_live_grep()
  require("telescope.builtin").live_grep(themes.get_dropdown {
    cwd = maybe_git_root(),
  })
end

local function custom_buffers()
  require("telescope.builtin").buffers(themes.get_dropdown())
end

local function custom_help_tags()
  require("telescope.builtin").help_tags(themes.get_dropdown {
    previewer = false
  })
end

nnoremap("<leader>ff", custom_find_files)
nnoremap("<leader>fg", custom_live_grep)
nnoremap("<leader>fb", custom_buffers)
nnoremap("<leader>fh", custom_help_tags)
