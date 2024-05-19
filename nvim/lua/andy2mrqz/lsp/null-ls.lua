local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	print("null-ls failed to load")
	return
end

local lsp_handlers = require("andy2mrqz.lsp.handlers")

null_ls.setup({
	debug = false,
	sources = {
		require("none-ls-shellcheck.code_actions"),
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt.with({
			extra_args = { "-ci", "-s", "-bn" },
		}),
		require("none-ls.formatting.rustfmt"),
		require("none-ls-shellcheck.diagnostics").with({
			extra_args = { "--shell=bash" },
			filetypes = { "zsh", "sh", "bash" },
		}),
		null_ls.builtins.diagnostics.mypy,
	},
	on_attach = lsp_handlers.on_attach,
})
