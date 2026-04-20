vim.diagnostic.config({
	virtual_text = true,
	signs = {
		-- active = signs,
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

vim.lsp.buf.hover = (function(original)
	return function(opts)
		opts = vim.tbl_extend("force", { border = "rounded", width = 60 }, opts or {})
		return original(opts)
	end
end)(vim.lsp.buf.hover)

vim.lsp.buf.signature_help = (function(original)
	return function(opts)
		opts = vim.tbl_extend("force", { border = "rounded", width = 60 }, opts or {})
		return original(opts)
	end
end)(vim.lsp.buf.signature_help)
