require("andy2mrqz.lsp.packages") -- Setup mason
require("andy2mrqz.lsp.config")
local h = require("andy2mrqz.lsp.handlers")
vim.lsp.config("*", { on_attach = h.on_attach, capabilities = h.capabilities })
local servers = require("andy2mrqz.lsp.servers")
for _, server in ipairs(servers) do
	local ok, custom = pcall(require, "andy2mrqz.lsp.settings." .. server)
	if ok then
		vim.lsp.config(server, custom)
	end
end
vim.lsp.enable(servers)
require("andy2mrqz.lsp.null-ls")
