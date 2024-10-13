local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	print("toggleterm failed to load")
	return
end

-- :help toggleterm
toggleterm.setup()

local Terminal = require("toggleterm.terminal").Terminal

local node = Terminal:new({ cmd = "node", hidden = true })

function _NODE_TOGGLE()
	node:toggle()
end
