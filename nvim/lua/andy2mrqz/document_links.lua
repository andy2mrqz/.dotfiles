-- Heavily inspired/borrowed from https://github.com/icholy/lsplinks.nvim/blob/master/lua/lsplinks.lua
-- Document Links
-- Provides LSP document link support with underlining, hover preview, and navigation
local M = {}

local ns = vim.api.nvim_create_namespace("document_links")
local cache = {} -- buffer -> links

-- Check if cursor is within a link range
local function cursor_in_range(cursor_row, cursor_col, range)
	local start_line, end_line = range.start.line, range["end"].line
	local start_col, end_col = range.start.character, range["end"].character
	if cursor_row < start_line or cursor_row > end_line then
		return false
	end
	if cursor_row == start_line and cursor_col < start_col then
		return false
	end
	if cursor_row == end_line and cursor_col >= end_col then
		return false
	end
	return true
end

-- Get link under cursor from cache (exported for conditional checks)
M.under_cursor = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local buf_links = cache[bufnr]
	if not buf_links then
		return nil
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1
	local col = cursor[2]

	for _, link in ipairs(buf_links) do
		if cursor_in_range(row, col, link.range) then
			return link
		end
	end
	return nil
end

-- Apply underline highlighting to all links
local function highlight_links(bufnr, links)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	for _, link in ipairs(links) do
		local range = link.range
		-- Handle single-line and multi-line links
		if range.start.line == range["end"].line then
			vim.api.nvim_buf_set_extmark(bufnr, ns, range.start.line, range.start.character, {
				end_col = range["end"].character,
				hl_group = "Underlined",
			})
		else
			-- Multi-line: underline each line
			for line = range.start.line, range["end"].line do
				local start_col = line == range.start.line and range.start.character or 0
				local end_col = line == range["end"].line and range["end"].character or -1
				vim.api.nvim_buf_set_extmark(bufnr, ns, line, start_col, {
					end_col = end_col ~= -1 and end_col or nil,
					end_row = end_col == -1 and line + 1 or nil,
					hl_group = "Underlined",
				})
			end
		end
	end
end

-- Refresh document links for a buffer
M.refresh = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Check if any attached client supports documentLink
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local has_support = false
	for _, client in ipairs(clients) do
		if client.server_capabilities.documentLinkProvider then
			has_support = true
			break
		end
	end
	if not has_support then
		return
	end

	local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
	vim.lsp.buf_request(bufnr, "textDocument/documentLink", params, function(err, result)
		if err or not result then
			cache[bufnr] = {}
			vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
			return
		end
		cache[bufnr] = result
		highlight_links(bufnr, result)
	end)
end

-- Open document link under cursor (or fallback to <cfile>)
M.open = function()
	local link = M.under_cursor()
	local target = link and link.target or vim.fn.expand("<cfile>")
	if not target or target == "" then
		return
	end
	-- Open file:// URIs in Neovim, others externally
	if target:find("^file:/") then
		local uri = target:gsub("#.*$", "") -- remove fragment
		vim.lsp.util.show_document({ uri = uri }, "utf-8", { reuse_win = true, focus = true })
		local line, col = target:match("#(%d+),(%d+)")
		if line then
			vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
		end
	else
		vim.ui.open(target)
	end
end

-- Show link target in hover float (pass link to avoid redundant under_cursor call)
M.hover = function(link)
	link = link or M.under_cursor()
	if link and link.target then
		vim.lsp.util.open_floating_preview({ link.target }, "markdown", {
			border = "rounded",
			focus = false,
		})
	end
end

-- Jump to next/prev document link
local function jump_link(forward)
	local links = cache[vim.api.nvim_get_current_buf()]
	if not links or #links == 0 then
		vim.notify("No document links in buffer", vim.log.levels.INFO)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	-- Compare link position to cursor: 1 = after, -1 = before, 0 = at
	local function cmp(s)
		if s.line ~= row then
			return s.line > row and 1 or -1
		end
		if s.character ~= col then
			return s.character > col and 1 or -1
		end
		return 0
	end

	local dir = forward and 1 or -1
	for i = forward and 1 or #links, forward and #links or 1, dir do
		local s = links[i].range.start
		if cmp(s) == dir then
			vim.api.nvim_win_set_cursor(0, { s.line + 1, s.character })
			return
		end
	end
	-- Wrap around
	local s = links[forward and 1 or #links].range.start
	vim.api.nvim_win_set_cursor(0, { s.line + 1, s.character })
end

M.next = function()
	jump_link(true)
end
M.prev = function()
	jump_link(false)
end

-- Setup autocmds for document links (call from on_attach)
M.setup = function(bufnr)
	local group = vim.api.nvim_create_augroup("DocumentLinks_" .. bufnr, { clear = true })

	-- Refresh on file load and after changes settle
	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TextChanged" }, {
		group = group,
		buffer = bufnr,
		callback = function()
			-- Debounce: slight delay to avoid hammering LSP
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					M.refresh(bufnr)
				end
			end, 200)
		end,
	})

	-- Clean up cache when buffer is deleted
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		buffer = bufnr,
		callback = function()
			cache[bufnr] = nil
		end,
	})

	-- Initial refresh
	M.refresh(bufnr)
end

return M
