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

whichkey.register({
	["<leader>"] = {
		["<leader>"] = { U.custom_find_files, "Find file" },
		["/"] = { U.custom_live_grep, "Search project" },
		["b"] = { U.custom_find_buffers, "Find Buffer" },
		["e"] = { ":NvimTreeToggle<cr>", "Open sidebar" },
		["w"] = {
			name = "window",
			["j"] = { "<C-w>j", "window down" },
			["k"] = { "<C-w>k", "window up" },
			["h"] = { "<C-w>h", "window left" },
			["l"] = { "<C-w>l", "window right" },
		},
		["g"] = {
			name = "git",
			["b"] = { ":Gitsigns toggle_current_line_blame<cr>", "toggle blame" },
			["d"] = { ":Gitsigns diffthis<cr>", "diff this" },
		},
		["f"] = {
			name = "file",
			["f"] = { U.custom_find_files, "find file" },
			["r"] = { U.custom_old_files, "recently used" },
		},
		["t"] = {
			name = "terminal",
			["t"] = { ":ToggleTerm direction=horizontal<cr>", "terminal" },
			["n"] = { ":lua _NODE_TOGGLE()<cr>", "node" },
			["r"] = { ":lua _CLJREPL_TOGGLE()", "clojure repl" },
		},
		["s"] = {
			name = "search",
			["h"] = { U.custom_help_tags, "find help" },
		},
	},
	["gx"] = { ':call jobstart(["open", expand("<cfile>")])<cr>', "open in browser" },
})
