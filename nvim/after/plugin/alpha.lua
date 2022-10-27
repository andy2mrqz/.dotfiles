local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[]],
	[[]],
	[[]],
	[[]],
	[[                ~+                                 ]],
	[[                                                   ]],
	[[                       *       +                   ]],
	[[                 '                  |              ]],
	[[             ()    .-.,="``"=.    - o -            ]],
	[[                   '=/_       \     |              ]],
	[[                *   |  '=._    |                   ]],
	[[                     \     `=./`,        '         ]],
	[[                  .   '=.__.=' `='      *          ]],
	[[         +                         +               ]],
	[[              O      *        '       .            ]],
	[[]],
	[[]],
	[[]],
	[[]],
	[[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
	[[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
	[[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
	[[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]],
	[[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
	[[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
	[[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]],
	[[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ]],
	[[         ░    ░  ░    ░ ░        ░   ░         ░   ]],
	[[                                ░                  ]],
}
dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <cr>"),
	dashboard.button("SPC f f", "  Find file"),
	dashboard.button("SPC f r", "  Recently used files"),
	dashboard.button("SPC /", "  Find text"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <cr>"),
	dashboard.button("q", "  Quit Neovim", ":qa<cr>"),
}

dashboard.section.footer.val = ""

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Type"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
