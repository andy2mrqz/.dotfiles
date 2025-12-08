local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	print("nvim-tree failed to load")
	return
end

-- :help nvim-tree-default-mappings
nvim_tree.setup({
	prefer_startup_root = true,
	update_focused_file = {
		enable = true,
	},
	renderer = {
		full_name = true, -- shows full name in floating window overlapping with buffer
		indent_width = 1,
		indent_markers = {
			enable = true,
		},
	},
	git = { enable = true, ignore = false },
	filters = { dotfiles = false },
})
