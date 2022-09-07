local status_ok, comment = pcall(require, "comment")
if not status_ok then
  print("Comment.nvim failed to load")
  return
end

comment.setup {
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  hook = require("ts_context_commentstring.internal").update_commentstring(),
}
