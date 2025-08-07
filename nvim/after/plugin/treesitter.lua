require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- Which parsers to install
	sync_install = false, -- Whether installation of parsers should be synchronous
	ignore_install = {
		"phpdoc",
	}, -- List of parsers to ignore
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false, -- Don't use vim regex for faster performance
		disable = function(_, buffnr)
			local buf_name = vim.api.nvim_buf_get_name(buffnr)
			local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
			return file_size > 256 * 1024 -- Disable highlighting for files larger than 256KB
		end,
	},
	indent = {
		enable = true,
		disable = { "" },
	},
})
