vim.opt.fileencoding = "utf-8" -- set file encoding
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = false -- set relative numbered lines
vim.opt.tabstop = 2 -- actual tabs display as this many spaces
vim.opt.softtabstop = 2 -- tabs become spaces
vim.opt.shiftwidth = 2 -- width to shift from >> key
vim.opt.expandtab = true -- tabs become spaces in insert mode
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- respects case in searching if uppercase present
vim.opt.wrap = true -- text wrapping
vim.opt.smartindent = true -- better indentation
vim.opt.autochdir = false -- (false is default - true breaks things!) changes working directory when switching buffers
vim.opt.hidden = true -- allow switching buffers without saving
vim.opt.undofile = true -- persistent undo
vim.opt.signcolumn = "yes" -- always show the signcolumn (git gutter, linting)
vim.opt.cursorline = true -- highlight current line
vim.opt.pumheight = 10 -- limit popup window to 10 items
vim.opt.splitbelow = true -- always open splits below
vim.opt.splitright = true -- always open splits to the right
vim.opt.winbar = "%F" -- add filename to top of neovim
vim.opt.statusline = "%F %m %h %r " -- file info
	.. "bufn=%n " -- buffer number
	.. "line=%l/%L=%p%% " -- line info
	.. "col=%v " -- column info
	.. "words=%{mode() =~# '^[vV\x16]' ? " -- if in visual mode (v,V,CTRL-V)
	.. "wordcount().visual_words : " -- show visual word count
	.. "wordcount().cursor_words}/%{wordcount().words}" -- else, show cursor word count
vim.opt.laststatus = 3 -- only show one statusline when many are open
vim.opt.clipboard = "unnamed" -- yank to system clipboard
vim.opt.list = true -- show tabs and spaces in special ways :help options, search nolist
vim.opt.listchars:append("trail:⋅") -- :help listchars
vim.g.copilot_filetypes = { gitcommit = true } -- enable copilot for gitcommit filetype
vim.opt.mps:append("<:>") -- match pairs for % key (adds <:> for HTML tags)
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HIGHLIGHTED_YANK", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

local FT_DETECT_GROUP = vim.api.nvim_create_augroup("FILETYPE_DETECT", {})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = FT_DETECT_GROUP,
	pattern = "*.code-workspace",
	callback = function()
		vim.api.nvim_set_option_value("filetype", "json", { scope = "local" })
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = FT_DETECT_GROUP,
	pattern = "*.gitignore",
	callback = function()
		vim.api.nvim_set_option_value("filetype", "gitignore", { scope = "local" })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("FORMAT_ON_SAVE", {}),
	pattern = "*.md",
	callback = function()
		-- Skip formatting for files in worknotes directory
		if vim.fn.expand("%:p"):match("WorkNotes") then
			return
		end

		-- Save cursor position
		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		-- Run Prettier
		vim.cmd("silent! %!prettier --parser markdown --print-width 80 --prose-wrap always")

		-- Clamp the cursor position to the last line of the buffer (if previous line was deleted)
		local last_line = vim.api.nvim_buf_line_count(0)
		local restored_line = math.min(cursor_pos[1], last_line)

		-- Restore cursor position
		vim.api.nvim_win_set_cursor(0, { restored_line, cursor_pos[2] })
	end,
})
