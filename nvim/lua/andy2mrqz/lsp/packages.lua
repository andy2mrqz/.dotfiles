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

local status_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not status_ok then
  print("mason-lspconfig failed to load")
  return
end

mason_lsp_config.setup {
  ensure_installed = {
    "sumneko_lua",
    "typescript-language-server",
    "clojure-lsp",
    "rust_analyzer",
    "gopls",
  }
  ,
  automatic_installation = true,
}
