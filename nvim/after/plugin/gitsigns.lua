local gitsigns_status_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_status_ok then
  return
end

gitsigns.setup {
  current_line_blame = false,
  current_line_blame_formatter = function(name, blame_info, opts)
    if blame_info.author == name then
      blame_info.author = 'You'
    end

    local text
    if blame_info.author == 'Not Committed Yet' then
      text = blame_info.author
    else
      local seconds_diff = os.time() - tonumber(blame_info['author_time'])
      local days_since = seconds_diff/60/60/24
      local date_time = days_since < 2 and
      require('gitsigns.util').get_relative_time(tonumber(blame_info['author_time']))
      or
      os.date('%Y-%m-%d', tonumber(blame_info['author_time']))
      text = string.format('%s, %s - %s (%s)', blame_info.author, date_time, blame_info.summary, blame_info.abbrev_sha)
    end
    return {{' '..text, 'GitSignsCurrentLineBlame'}}
  end,
  current_line_blame_opts = {
    delay = 50,
    virt_text_pos = 'eol'
  },
}
