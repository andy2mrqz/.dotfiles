local whichkey = require("which-key")
local telescope = require("telescope.builtin")
local nnoremap = require("andy2mrqz.keymaps").nnoremap
local inoremap = require("andy2mrqz.keymaps").inoremap
local U = require("andy2mrqz.utils")
local links = require("andy2mrqz.document_links")

local M = {}

M.on_attach = function(client, bufnr)
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
		{
			"<leader>co",
			function()
				vim.cmd("copen")
			end,
			desc = "open quickfix list",
		},
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
		{ "gx", links.open, desc = "open document link" },
		-- Document links group
		{ "<leader>l", group = "document links" },
		{ "<leader>lh", links.hover, desc = "hover document link" },
		{ "<leader>ln", links.next, desc = "next document link" },
		{ "<leader>lp", links.prev, desc = "previous document link" },
	})

	nnoremap("K", function()
		local link = links.under_cursor()
		if link then
			links.hover(link)
		else
			vim.lsp.buf.hover()
		end
	end)
	inoremap("<C-k>", vim.lsp.buf.signature_help)

	-- Setup document link highlighting and caching
	links.setup(bufnr)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	print("cmp_nvim_lsp failed to load")
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
