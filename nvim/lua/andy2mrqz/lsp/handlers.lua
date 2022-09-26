local whichkey = require("which-key")
local telescope = require("telescope.builtin")
local nnoremap = require("andy2mrqz.keymaps").nnoremap
local inoremap = require("andy2mrqz.keymaps").inoremap
local U = require("andy2mrqz.utils")

local M = {}

M.on_attach = function(client)
	client = client or {}
	whichkey.register({
		["<leader>"] = {
			["F"] = {
				function()
					vim.lsp.buf.format({ async = true })
				end,
				"Format buffer",
			},
			["d"] = {
				name = "diagnostic",
				["s"] = {
					function()
						vim.diagnostic.open_float()
					end,
					"show",
				},
				["q"] = {
					function()
						vim.diagnostic.setqflist()
					end,
					"set quickfix list",
				},
			},
			["r"] = {
				name = "refactor",
				["n"] = { vim.lsp.buf.rename, "rename" },
			},
			["c"] = {
				name = "code",
				["a"] = { vim.lsp.buf.code_action, "actions" },
			},
		},
		["g"] = {
			["d"] = { telescope.lsp_definitions, "go to definition" },
			["D"] = { telescope.type_definitions, "go to type definition" },
			["i"] = { telescope.lsp_implementations, "go to implementations" },
			["r"] = { U.custom_lsp_references, "go to references" },
		},
	})

	nnoremap("K", vim.lsp.buf.hover)
	inoremap("<C-k>", vim.lsp.buf.signature_help)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	print("cmp_nvim_lsp failed to load")
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
