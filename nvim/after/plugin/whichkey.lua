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
	{
		"<leader>gb",
		function()
			-- Look for an existing gitsigns-blame buffer
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
				if ft == "gitsigns-blame" then
					-- Found it!  Close the window now
					vim.api.nvim_win_close(win, true)
					return
				end
			end
			-- Not open, so open it!
			vim.cmd("Gitsigns blame")
		end,
		desc = "toggle blame sidebar",
	},
	{ "<leader>gd", ":Gitsigns diffthis<cr>", desc = "diff this" },
	{
		"<leader>gs",
		function()
			-- Open split and run git-stats in terminal
			vim.cmd("split")
			vim.cmd("term bash -c 'git-stats; sleep 5'")

			-- Get the buffer number of the terminal
			local term_buf = vim.api.nvim_get_current_buf()

			-- Defer closing just that buffer
			vim.defer_fn(function()
				-- Check if the buffer is still valid (not already closed)
				if vim.api.nvim_buf_is_valid(term_buf) then
					vim.api.nvim_buf_delete(term_buf, { force = true })
				end
			end, 5000)
		end,
		desc = "Show git stats briefly in bottom split",
	},
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
