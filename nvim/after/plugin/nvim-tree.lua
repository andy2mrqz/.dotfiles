local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  print("nvim-tree failed to load")
  return
end

-- :help nvim-tree-default-mappings
nvim_tree.setup({
  git = { enable = true, ignore = false },
  filters = { dotfiles = true }
})

