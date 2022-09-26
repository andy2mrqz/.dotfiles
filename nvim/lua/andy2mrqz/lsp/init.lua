local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	print("lspconfig failed to load")
	return
end

require("andy2mrqz.lsp.packages") -- Setup mason
require("andy2mrqz.lsp.config")
local servers = require("andy2mrqz.lsp.servers")
local lsp_handlers = require("andy2mrqz.lsp.handlers")

for _, server in pairs(servers) do
	local opts = {
		on_attach = lsp_handlers.on_attach,
		capabilities = lsp_handlers.capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "andy2mrqz.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

require("andy2mrqz.lsp.null-ls")
