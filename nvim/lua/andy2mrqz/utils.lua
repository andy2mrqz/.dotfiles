local M = {}

local themes = require("telescope.themes")
local telescope = require("telescope.builtin")

-- nil or string
M.maybe_git_root = function()
	return vim.fn.systemlist("git rev-parse --show-toplevel 2> /dev/null")[1]
end

M.custom_find_files = function()
	if M.maybe_git_root() ~= nil then
		telescope.git_files({
			show_untracked = true,
		})
	else
		telescope.find_files()
	end
end

M.custom_live_grep = function()
	telescope.live_grep({
		cwd = M.maybe_git_root(),
	})
end

M.custom_find_buffers = function()
	telescope.buffers(themes.get_dropdown())
end

M.custom_help_tags = function()
	telescope.help_tags(themes.get_dropdown({
		previewer = false,
	}))
end

M.custom_lsp_definitions = function()
	local params = vim.lsp.util.make_position_params(0, "utf-8")

	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
		if err then
			vim.notify("LSP error: " .. err.message, vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No definition found", vim.log.levels.INFO)
			return
		end

		-- Normalize + dedupe results (same file and line)
		local seen = {}
		local deduped = {}
		for _, def in ipairs(result) do
			local uri = def.targetUri
			local range = def.targetSelectionRange

			if uri and range and range.start and range.start.line then
				local key = uri .. ":" .. range.start.line
				if not seen[key] then
					seen[key] = true
					table.insert(deduped, def)
				end
			else
				table.insert(deduped, def)
			end
		end

		if #deduped == 1 then
			local def = deduped[1]
			-- target vs bare variants - can be either depending on context
			local uri = def.targetUri or def.uri
			local range = def.targetSelectionRange or def.range

			-- current buffer + position
			local cur_buf = vim.api.nvim_get_current_buf()
			local cur_name = vim.api.nvim_buf_get_name(cur_buf)
			local cur_pos = vim.api.nvim_win_get_cursor(0) -- {line, col}, 1-based line

			-- target buffer + position from LSP result
			local target_fname = vim.uri_to_fname(uri)
			local target_line = range.start.line + 1

			-- If we're already at the definition, show references instead
			if cur_name == target_fname and cur_pos[1] == target_line then
				telescope.lsp_references()
			end

			vim.lsp.util.show_document(result[1], "utf-8")
			vim.cmd("normal! zz")
		else
			telescope.lsp_definitions()
		end
	end)
end

return M
