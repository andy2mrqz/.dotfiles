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
		["."] = { U.custom_find_files, "Find file" },
		["/"] = { U.custom_live_grep, "Search project" },
		["b"] = { U.custom_find_buffers, "Find Buffer" },
		["e"] = { ":Lex 40<cr>", "Open sidebar" },
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
		},
		["f"] = {
			name = "file",
			["f"] = { U.custom_find_files, "find file" },
		},
		["s"] = {
			name = "search",
			["h"] = { U.custom_help_tags, "find help" },
		},
	},
})

