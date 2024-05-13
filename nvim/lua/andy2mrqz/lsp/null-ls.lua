local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	print("null-ls failed to load")
	return
end

-- todo: move to https://github.com/nvimtools/none-ls.nvim

local lsp_handlers = require("andy2mrqz.lsp.handlers")

null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt.with({
			extra_args = { "-ci", "-s", "-bn" },
		}),
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.diagnostics.shellcheck.with({
			extra_args = { "--shell=bash" },
			filetypes = { "zsh", "sh", "bash" },
		}),
		null_ls.builtins.diagnostics.mypy,
	},
	on_attach = lsp_handlers.on_attach,
})
