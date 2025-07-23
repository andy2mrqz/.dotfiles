local status_ok, mason = pcall(require, "mason")
if not status_ok then
	print("mason failed to load")
	return
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local mason_status_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not mason_status_ok then
	print("mason-lspconfig failed to load")
	return
end

-- I think this was causing double-start of LSP servers
-- mason_lsp_config.setup({
-- 	ensure_installed = vim.tbl_filter(function(server)
-- 		local ok, config = pcall(require, "andy2mrqz.lsp.settings." .. server)
-- 		return not (ok and config.mason == false)
-- 	end, require("andy2mrqz.lsp.servers")),
-- 	automatic_installation = true,
-- })
