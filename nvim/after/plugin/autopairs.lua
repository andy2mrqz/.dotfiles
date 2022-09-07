local status_ok, npairs = pcall(require, 'nvim-autopairs')
if not status_ok then
  print("nvim-autopairs failed to load")
  return
end

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
  }
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  print("cmp failed to load")
  return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

