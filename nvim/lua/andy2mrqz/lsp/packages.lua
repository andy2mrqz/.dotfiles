local status_ok, mason = pcall(require, "mason")
if not status_ok then
  print("mason failed to load")
  return
end

local lspconfig = require("lspconfig")

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

local servers = {
    "sumneko_lua",
    "tsserver",
    "clojure_lsp",
    "rust_analyzer",
    "gopls",
  }

mason_lsp_config.setup {
  ensure_installed = servers
  ,
  automatic_installation = true,
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("andy2mrqz.lsp.handlers").on_attach,
    capabilities = require("andy2mrqz.lsp.handlers").capabilities,
  }
  lspconfig[server].setup(opts)
end
