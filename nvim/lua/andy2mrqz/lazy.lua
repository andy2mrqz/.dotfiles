--
-- Automatically installs lazy.nvim if not installed
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- Plugins to install
lazy.setup({
	-- Colorscheme (eager, loads first)
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				overrides = function(_colors)
					return {
						Search = { bg = "NvimDarkYellow" },
					}
				end,
			})
			vim.cmd("colorscheme kanagawa")
		end,
	},

	-- snacks utility library (eager, provides bigfile/gitbrowse/indent)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			gitbrowse = { enabled = true },
			indent = { enabled = true },
		},
	},

	-- Git
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame = true,
			current_line_blame_formatter = function(name, blame_info, _)
				if blame_info.author == name then
					blame_info.author = "You"
				end

				local text
				if blame_info.author == "Not Committed Yet" then
					text = blame_info.author
				else
					local seconds_diff = os.time() - tonumber(blame_info["author_time"])
					local days_since = seconds_diff / 60 / 60 / 24
					local date_time = days_since < 2
							and require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
						or os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
					text = string.format(
						"%s, %s - %s (%s)",
						blame_info.author,
						date_time,
						blame_info.summary,
						blame_info.abbrev_sha
					)
				end
				return { { " " .. text, "GitSignsCurrentLineBlame" } }
			end,
			current_line_blame_opts = {
				delay = 50,
				virt_text_pos = "eol",
			},
		},
	},

	-- Copilot
	{
		"github/copilot.vim",
		cmd = "Copilot",
	},

	-- Treesitter (eager on main branch)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Which-key (keymap discovery)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				breadcrumb = "»",
				separator = "",
				group = "+",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			local U = require("andy2mrqz.utils")
			wk.setup(opts)

			local gs = require("gitsigns")

			wk.add({
				-- Leader group
				{ "<leader>", group = "leader key" },
				{ "<leader><leader>", U.custom_find_files, desc = "Find file" },
				{ "<leader>/", U.custom_live_grep, desc = "Search project" },
				{ "<leader>b", U.custom_find_buffers, desc = "Find Buffer" },
				{ "<leader>e", ":NvimTreeToggle<cr>", desc = "Open sidebar" },
				-- Window group
				{ "<leader>w", group = "window" },
				{ "<leader>wj", "<C-w>j", desc = "window down" },
				{ "<leader>wk", "<C-w>k", desc = "window up" },
				{ "<leader>wh", "<C-w>h", desc = "window left" },
				{ "<leader>wl", "<C-w>l", desc = "window right" },
				-- Git group
				{ "<leader>g", group = "git" },
				{
					"<leader>gb",
					function()
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
							if ft == "gitsigns-blame" then
								vim.api.nvim_win_close(win, true)
								return
							end
						end
						gs.blame()
					end,
					desc = "toggle blame sidebar",
				},
				{ "<leader>gd", gs.diffthis, desc = "diff this" },
				{
					"<leader>gs",
					function()
						vim.cmd("split")
						vim.cmd("term bash -c 'git-stats; sleep 5'")
						local term_buf = vim.api.nvim_get_current_buf()
						vim.defer_fn(function()
							if vim.api.nvim_buf_is_valid(term_buf) then
								vim.api.nvim_buf_delete(term_buf, { force = true })
							end
						end, 5000)
					end,
					desc = "Show git stats briefly in bottom split",
				},
				-- (git) Hunk group
				{ "<leader>h", group = "hunk" },
				{ "<leader>hr", gs.reset_hunk, desc = "reset hunk" },
				{ "<leader>hs", gs.stage_hunk, desc = "stage hunk" },
				{ "<leader>hv", gs.preview_hunk, desc = "view hunk" },
				{
					"<leader>hn",
					function()
						gs.nav_hunk("next", { preview = true, greedy = false, target = "all" })
					end,
					desc = "next hunk",
				},
				{
					"<leader>hp",
					function()
						gs.nav_hunk("prev", { preview = true, greedy = false, target = "all" })
					end,
					desc = "previous hunk",
				},
				-- Terminal group
				{ "<leader>t", group = "terminal" },
				{ "<leader>tt", ":ToggleTerm direction=horizontal<cr>", desc = "terminal" },
				{ "<leader>tn", ":lua _NODE_TOGGLE()<cr>", desc = "node" },
				-- Yank group
				{ "<leader>y", group = "yank" },
				{
					"<leader>yp",
					function()
						local line = vim.fn.line(".")
						local result = U.file_ref(line, line)
						vim.fn.setreg("+", result)
						vim.notify(result, vim.log.levels.INFO)
					end,
					desc = "copy relative path:line",
				},
				{
					"<leader>yp",
					function()
						local line1 = vim.fn.line("v")
						local line2 = vim.fn.line(".")
						local result = U.file_ref(math.min(line1, line2), math.max(line1, line2))
						vim.fn.setreg("+", result)
						vim.schedule(function()
							vim.notify(result, vim.log.levels.INFO)
						end)
					end,
					mode = "v",
					desc = "copy relative path:lines",
				},
				{
					"<leader>yP",
					function()
						local line = vim.fn.line(".")
						local result = U.file_ref(line, line, { relative = false })
						vim.fn.setreg("+", result)
						vim.notify(result, vim.log.levels.INFO)
					end,
					desc = "copy absolute path:line",
				},
				{
					"<leader>yP",
					function()
						local line1 = vim.fn.line("v")
						local line2 = vim.fn.line(".")
						local result = U.file_ref(math.min(line1, line2), math.max(line1, line2), { relative = false })
						vim.fn.setreg("+", result)
						vim.schedule(function()
							vim.notify(result, vim.log.levels.INFO)
						end)
					end,
					mode = "v",
					desc = "copy absolute path:lines",
				},
				-- Diagnostic group (LSP-agnostic; works with any diagnostic source, e.g. nvim-lint)
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
				{
					"<leader>dn",
					function()
						vim.diagnostic.jump({ count = 1 })
					end,
					desc = "next diagnostic",
				},
				{
					"<leader>dp",
					function()
						vim.diagnostic.jump({ count = -1 })
					end,
					desc = "previous diagnostic",
				},
				{
					"]d",
					function()
						vim.diagnostic.jump({ count = 1 })
					end,
					desc = "next diagnostic",
				},
				{
					"[d",
					function()
						vim.diagnostic.jump({ count = -1 })
					end,
					desc = "previous diagnostic",
				},
				-- Quickfix group
				{ "<leader>c", group = "quickfix/code" },
				{
					"<leader>co",
					function()
						vim.cmd("copen")
					end,
					desc = "open quickfix list",
				},
				-- Miscellaneous
				{ "<leader>fe", ":NvimTreeFindFile<cr>", desc = "nvim tree find file" },
				{ "<leader>sh", U.custom_help_tags, desc = "find help" },
			})
		end,
	},

	-- Session manager (must be eager to restore on startup)
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = {
				"~/",
				"~/Downloads",
				"/",
			},
			-- Don't pull in the telescope picker at startup; it'll load on demand
			session_lens = { load_on_setup = false },
		},
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		keys = {
			{ "<leader>tt", ":ToggleTerm direction=horizontal<cr>", desc = "terminal" },
			{ "<leader>tn", ":lua _NODE_TOGGLE()<cr>", desc = "node" },
		},
		config = function()
			require("toggleterm").setup()
			local Terminal = require("toggleterm.terminal").Terminal
			local node = Terminal:new({ cmd = "node", hidden = true })
			function _NODE_TOGGLE()
				node:toggle()
			end
		end,
	},

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zz", "zt", "zb" },
		config = function()
			require("neoscroll").setup()
		end,
	},

	-- File tree
	{
		"kyazdani42/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
		keys = { { "<leader>e", ":NvimTreeToggle<cr>", desc = "Open sidebar" } },
		dependencies = { "kyazdani42/nvim-web-devicons" },
		-- :help nvim-tree-default-mappings
		opts = {
			prefer_startup_root = true,
			update_focused_file = {
				enable = true,
			},
			renderer = {
				full_name = true, -- shows full name in floating window overlapping with buffer
				indent_width = 1,
				indent_markers = {
					enable = true,
				},
			},
			git = { enable = true, ignore = false },
			filters = { dotfiles = false },
		},
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		lazy = false, -- needed on rtp for vim.lsp.enable() in lsp/init.lua
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false, -- This plugin is already lazy
	},
	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				rust = { "rustfmt" },
				go = { "goimports" },
				tf = { "terraform_fmt" },
				terraform = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-ci", "-s", "-bn" },
				},
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
		},
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				zsh = { "shellcheck" },
				python = { "ruff" },
				go = { "golangcilint" },
			}
			-- Treat zsh/sh/bash as bash for shellcheck
			lint.linters.shellcheck.args =
				vim.list_extend(vim.deepcopy(lint.linters.shellcheck.args or {}), { "--shell=bash" })

			local group = vim.api.nvim_create_augroup("andy2mrqz_lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
				group = group,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.api.nvim_create_user_command("LintInfo", function()
				local ft = vim.bo.filetype
				local names = lint.linters_by_ft[ft] or {}
				if #names == 0 then
					print("No linters configured for filetype: " .. ft)
					return
				end
				local lines = { "Linters for " .. ft .. ":" }
				for _, name in ipairs(names) do
					local linter = lint.linters[name]
					local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
					local available = cmd and vim.fn.executable(cmd) == 1
					table.insert(
						lines,
						string.format("  %s - %s (%s)", name, cmd or "?", available and "installed" or "MISSING")
					)
				end
				print(table.concat(lines, "\n"))
			end, {})
		end,
	},

	-- Lua dev completion
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				"lazy.nvim",
				"~/.local/share/nvim/lazy/",
			},
		},
	},

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		lazy = false, -- eager so LSP capabilities are available at startup
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "none",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					window = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					},
				},
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		opts = {
			pickers = {
				buffers = {
					mappings = {
						n = {
							["dd"] = "delete_buffer",
						},
					},
				},
			},
			defaults = {
				sorting_strategy = "ascending",
				winblend = 15,
				path_display = { "filename_first" },
				file_ignore_patterns = { "^.git/" },
				dynamic_preview_title = true,
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
					"--ignore-case",
					"--sort=path", -- match case with vscode search (alphabetical)
				},
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<C-n>"] = "cycle_history_next",
						["<C-p>"] = "cycle_history_prev",
					},
				},
			},
		},
	},

	-- Editing helpers
	{
		"kylechui/nvim-surround",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
			},
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},

	-- Buffer / quickfix utilities
	{
		"moll/vim-bbye",
		cmd = { "Bdelete", "Bwipeout" },
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
}, {
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
