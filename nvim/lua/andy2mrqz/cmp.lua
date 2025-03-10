table.unpack = table.unpack or unpack -- 5.1 compatibility

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

cmp.setup({
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
	},
	window = {
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},
})
