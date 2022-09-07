local status_ok, comment = pcall(require, "comment")
if not status_ok then
  print("Comment.nvim failed to load")
  return
end

comment.setup {
  pre_hook = function (ctx)
    local U = require("Comment.utils")
    local ts_context_utils = require("ts_context_commentstring.utils")

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = ts_context_utils.get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.motion == U.cmotion.V then
      location = ts_context_utils.get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location
    }
  end,
}

