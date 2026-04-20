local nnoremap = require("andy2mrqz.keymaps").nnoremap
local inoremap = require("andy2mrqz.keymaps").inoremap
local U = require("andy2mrqz.utils")
local links = require("andy2mrqz.document_links")

local M = {}

M.on_attach = function(client, bufnr)
	client = client or {}
	local whichkey = require("which-key")
	whichkey.add({
		-- Leader group
		{ "<leader>", group = "leader key" },
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
		-- Quickfix/code (LSP-dependent entries only; see which-key spec in lazy.lua for LSP-agnostic ones)
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
		{
			"[c",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			desc = "go to context",
		},
		{ "gd", U.custom_lsp_definitions, desc = "go to definition" },
		{
			"gD",
			function()
				require("telescope.builtin").type_definitions()
			end,
			desc = "go to type definition",
		},
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

M.capabilities = require("blink.cmp").get_lsp_capabilities()

return M
