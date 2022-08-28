local status_ok, mason = pcall(require, "mason")
if not status_ok then
  print("mason failed to load")
  return
end

mason.setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}

local mason_status_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not mason_status_ok then
  print("mason-lspconfig failed to load")
  return
end

mason_lsp_config.setup {
  ensure_installed = require("andy2mrqz.lsp.servers"),
  automatic_installation = true,
}

