require("andy2mrqz.lsp.config")
local h = require("andy2mrqz.lsp.handlers")
-- Capabilities apply to every server enabled below. Keymaps are registered once
-- by h.setup() via a single LspAttach autocmd (covers these servers AND
-- rust-analyzer through rustaceanvim).
vim.lsp.config("*", { capabilities = h.capabilities })
h.setup()
local servers = require("andy2mrqz.lsp.servers")
for _, server in ipairs(servers) do
	local ok, custom = pcall(require, "andy2mrqz.lsp.settings." .. server)
	if ok then
		vim.lsp.config(server, custom)
	end
end
vim.lsp.enable(servers)
