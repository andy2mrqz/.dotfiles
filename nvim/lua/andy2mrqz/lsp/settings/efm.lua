local shellcheck = {
  LintCommand = "shellcheck -f gcc -x",
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' }
}
local shfmt = { formatCommand = 'shfmt -ci -s -bn', formatStdin = true }

return {
  init_options = {
    documentFormatting = true
  },
  filetypes = {
    "sh",
  },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      sh = { shellcheck, shfmt }
    }
  }
}
