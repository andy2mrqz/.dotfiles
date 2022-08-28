local nnoremap = require("andy2mrqz.keymaps").nnoremap

local M = {}

local lsp_formatter = function()
    vim.lsp.buf.format { async = true }
  end

M.on_attach = function(client, bufnr)
  -- Configure lsp Keymaps
  local bufopts = { silent = true, buffer = bufnr }
  nnoremap("gD", vim.lsp.buf.declaration, bufopts)
  nnoremap("gd", vim.lsp.buf.definition, bufopts)
  nnoremap("<space>D", vim.lsp.buf.type_definition, bufopts)
  nnoremap("<space>rn", vim.lsp.buf.rename, bufopts)
  nnoremap("<space>ca", vim.lsp.buf.code_action, bufopts)
  nnoremap("gr", vim.lsp.buf.references, bufopts)
  nnoremap("K", vim.lsp.buf.hover, bufopts)
  nnoremap("gi", vim.lsp.buf.implementation, bufopts)
  nnoremap("<C-k>", vim.lsp.buf.signature_help, bufopts)
  nnoremap("<space>f", lsp_formatter, bufopts)
end


local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  print("Couldn't require cmp_nvim_lsp")
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
