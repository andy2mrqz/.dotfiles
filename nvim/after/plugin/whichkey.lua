local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	print("whichkey failed to load")
	return
end

local U = require("andy2mrqz.utils")

whichkey.setup({
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
})

whichkey.add({
	-- Leader group
	{ "<leader>", group = "leader key" },
	{ "<leader><leader>", U.custom_find_files, desc = "Find file" },
	{ "<leader>/", U.custom_live_grep, desc = "Search project" },
	{ "<leader>b", U.custom_find_buffers, desc = "Find Buffer" },
	{ "<leader>e", ":NvimTreeToggle<cr>", desc = "Open sidebar" },
	-- Window group
	{ "<leader>w", group = "window" },
	{ "<leader>wj", "<C-w>j", desc = "window down" },
	{ "<leader>wk", "<C-w>k", desc = "window up" },
	{ "<leader>wh", "<C-w>h", desc = "window left" },
	{ "<leader>wl", "<C-w>l", desc = "window right" },
	-- Git group
	{ "<leader>g", group = "git" },
	{ "<leader>gb", ":Gitsigns toggle_current_line_blame<cr>", desc = "toggle blame" },
	{ "<leader>gd", ":Gitsigns diffthis<cr>", desc = "diff this" },
	{ "<leader>ghr", ":Gitsigns reset_hunk<cr>", desc = "reset hunk" },
	{ "<leader>ghs", ":Gitsigns stage_hunk<cr>", desc = "stage hunk" },
	-- Terminal group
	{ "<leader>t", group = "terminal" },
	{ "<leader>tt", ":ToggleTerm direction=horizontal<cr>", desc = "terminal" },
	{ "<leader>tn", ":lua _NODE_TOGGLE()<cr>", desc = "node" },
	-- Miscellanous group
	{ "<leader>fe", ":NvimTreeFindFile<cr>", desc = "nvim tree find file" },
	{ "<leader>sh", U.custom_help_tags, desc = "find help" },
	{ "gx", ':call jobstart(["open", expand("<cfile>")])<cr>', desc = "open in browser" },
	{ "]d", ":lua vim.diagnostic.goto_next() <cr>", desc = "next diagnostic" },
	{ "[d", ":lua vim.diagnostic.goto_prev() <cr>", desc = "previous diagnostic" },
})
