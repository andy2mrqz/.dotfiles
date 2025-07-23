local M = {}

local themes = require("telescope.themes")
local telescope = require("telescope.builtin")

-- nil or string
M.maybe_git_root = function()
	return vim.fn.systemlist("git rev-parse --show-toplevel 2> /dev/null")[1]
end

M.custom_find_files = function()
	if M.maybe_git_root() ~= nil then
		telescope.git_files(themes.get_dropdown({
			show_untracked = true,
		}))
	else
		telescope.find_files(themes.get_dropdown())
	end
end

M.custom_live_grep = function()
	telescope.live_grep(themes.get_dropdown({
		cwd = M.maybe_git_root(),
		additional_args = function()
			return { "--hidden" }
		end,
	}))
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
	local params = vim.lsp.util.make_position_params()

	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
		if err then
			vim.notify("LSP error: " .. err.message, vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No definition found", vim.log.levels.INFO)
			return
		end

		if #result == 1 then
			vim.lsp.util.jump_to_location(result[1], "utf-8")
			vim.cmd("normal! zz")
		else
			telescope.lsp_definitions(themes.get_dropdown())
		end
	end)
end

M.custom_lsp_references = function()
	telescope.lsp_references(themes.get_dropdown())
end

return M
