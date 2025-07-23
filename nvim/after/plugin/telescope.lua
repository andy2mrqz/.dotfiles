local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	print("telescope failed to load")
	return
end

telescope.setup({
	defaults = {
		winblend = 5,
		path_display = { shorten = { len = 1, exclude = { 1, -1 } } },
		file_ignore_patterns = {
			"^.git/",
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
