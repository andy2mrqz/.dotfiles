local whichkey = require("which-key")
local telescope = require("telescope.builtin")
local nnoremap = require("andy2mrqz.keymaps").nnoremap
local inoremap = require("andy2mrqz.keymaps").inoremap
local U = require("andy2mrqz.utils")

local M = {}

M.on_attach = function(client)
	client = client or {}
	whichkey.add({
		-- Leader group
		{ "<leader>", group = "leader key" },
		{
			"<leader>F",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = "Format buffer",
		},
		-- Diagnostic group
		{ "<leader>d", group = "diagnostic" },
		{
			"<leader>dq",
			function()
				vim.diagnostic.setqflist()
			end,
			desc = "set quickfix list",
		},
		{
			"<leader>ds",
			function()
				vim.diagnostic.open_float()
			end,
			desc = "show",
		},
		-- Quickfix/code
		{ "<leader>c", group = "quickifx/code" },
		{ "<leader>cn", function() vim.cmd("cnext") end, desc = "next quickfix item" },
		{ "<leader>cp", function() vim.cmd("cprev") end, desc = "previous quickfix item" },
		{ "<leader>cc", function() vim.cmd("cclose") end, desc = "close quickfix list" },
		{ "<leader>co", function() vim.cmd("copen") end, desc = "open quickfix list" },
		{ "<leader>cl", function() vim.cmd("clist") end, desc = "list quickfix items" },
		{
			"<leader>ca",
			function()
				vim.lsp.buf.code_action()
			end,
			desc = "code action",
		},
		-- Refactor group
		{ "<leader>r", group = "refactor" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "rename" },
		-- Go to group
		{ "g", group = "go to" },
		{ "gd", U.custom_lsp_definitions, desc = "go to definition" },
		{ "gD", telescope.type_definitions, desc = "go to type definition" },
		{ "gr", U.custom_lsp_references, desc = "go to references" },
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
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
