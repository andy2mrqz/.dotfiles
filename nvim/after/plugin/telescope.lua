local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	print("telescope failed to load")
	return
end

telescope.setup({
	pickers = {
		buffers = {
			mappings = {
				n = {
					["dd"] = "delete_buffer",
				},
			},
		},
	},
	defaults = {
		sorting_strategy = "ascending",
		-- layout_strategy = "center",
		-- layout_config = { anchor = "S", height = 0.65 },
		winblend = 15,
		path_display = { "filename_first" },
		file_ignore_patterns = { "^.git/" },
		dynamic_preview_title = true,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--hidden",
			"--ignore-case",
			"--sort=path", -- match case with vscode search (alphabetical)
		},
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",

				["<C-n>"] = "cycle_history_next",
				["<C-p>"] = "cycle_history_prev",
			},
		},
	},
})
