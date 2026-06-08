local nnoremap = require("andy2mrqz.keymaps").nnoremap
local inoremap = require("andy2mrqz.keymaps").inoremap
local U = require("andy2mrqz.utils")
local links = require("andy2mrqz.document_links")

local M = {}

M.capabilities = require("blink.cmp").get_lsp_capabilities()

-- Buffer-local LSP keymaps, applied when a client attaches so they only exist
-- where an LSP is actually running (no leaking `gd` into plain buffers). They're
-- real `vim.keymap.set` mappings with a `desc`; which-key renders the desc and
-- the group labels (registered in M.setup) automatically. LSP-agnostic entries
-- (`[c`, conform format) ride along intentionally so they're available wherever
-- you're editing real code.
local function attach_keymaps(bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = desc }
	end

	nnoremap("<leader>F", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, opts("Format buffer"))
	nnoremap("<leader>ca", vim.lsp.buf.code_action, opts("code action"))
	nnoremap("<leader>rn", vim.lsp.buf.rename, opts("rename"))
	nnoremap("[c", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, opts("go to context"))
	nnoremap("gd", U.custom_lsp_definitions, opts("go to definition"))
	nnoremap("gD", function()
		require("telescope.builtin").type_definitions()
	end, opts("go to type definition"))
	nnoremap("gx", links.open, opts("open document link"))
	nnoremap("<leader>lh", links.hover, opts("hover document link"))
	nnoremap("<leader>ln", links.next, opts("next document link"))
	nnoremap("<leader>lp", links.prev, opts("previous document link"))

	nnoremap("K", function()
		local link = links.under_cursor()
		if link then
			links.hover(link)
		else
			vim.lsp.buf.hover()
		end
	end, opts("hover"))
	inoremap("<C-k>", vim.lsp.buf.signature_help, opts("signature help"))

	-- Setup document link highlighting and caching
	links.setup(bufnr)
end

-- Single source of truth for LSP keymaps: one LspAttach autocmd that fires for
-- every client regardless of how it was started — servers enabled via
-- vim.lsp.enable() AND rust-analyzer (rustaceanvim, which bypasses
-- vim.lsp.config). Call once during LSP setup.
function M.setup()
	-- Group labels are LSP-agnostic, so register them once (not per buffer).
	require("which-key").add({
		{ "<leader>r", group = "refactor" },
		{ "<leader>l", group = "document links" },
		{ "g", group = "go to" },
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("andy2mrqz_lsp_attach", { clear = true }),
		callback = function(args)
			attach_keymaps(args.buf)
		end,
	})
end

return M
