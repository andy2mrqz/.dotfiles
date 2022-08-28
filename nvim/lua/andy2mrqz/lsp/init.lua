local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  print("lspconfig failed to load")
  return
end

require("andy2mrqz.lsp.packages")
require("andy2mrqz.lsp.handlers").setup()
