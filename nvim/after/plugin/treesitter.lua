-- nvim-treesitter `main` branch API.
-- The old `require("nvim-treesitter.configs").setup({...})` no longer exists;
-- highlight/indent are driven by autocmds, parsers are installed via install().

local ok, nt = pcall(require, "nvim-treesitter")
if not ok then
	return
end

-- Parsers to ensure are installed on startup.
-- Add more here as you need them; parser install is async and idempotent.
-- For ad-hoc installs, use `:TSInstall <lang>`.
local ensure_installed = {
	"bash",
	"c",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"graphql",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"ruby",
	"rust",
	"scss",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
}

pcall(nt.install, ensure_installed)

-- Enable highlighting + indent for any buffer whose filetype has an installed parser.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("andy2mrqz_treesitter", { clear = true }),
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "" then
			return
		end
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if not pcall(vim.treesitter.language.add, lang) then
			return
		end

		-- Skip highlighting for large files (matches previous 256KB threshold).
		local buf_name = vim.api.nvim_buf_get_name(args.buf)
		local file_size = vim.fn.getfsize(buf_name)
		if file_size > 256 * 1024 then
			return
		end

		pcall(vim.treesitter.start, args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
