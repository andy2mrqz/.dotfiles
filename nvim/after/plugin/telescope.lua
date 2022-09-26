local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  print("telescope failed to load")
  return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		winblend = 5,
		path_display = { shorten = { len = 1, exclude = { 1, -1 } } },
		file_ignore_patterns = {
			"^.git/",
		},
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
			},
		},
	},
})
