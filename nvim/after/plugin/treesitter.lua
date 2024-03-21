require('nvim-treesitter.configs').setup({
  ensure_installed = "all",                       -- Which parsers to install
  sync_install = false,                           -- Whether installation of parsers should be synchronous
  ignore_install = {
    "phpdoc"
  },                        -- List of parsers to ignore
  autopairs = {
    enable = true
  },
  autotag = {
    enable = true
  },
  highlight = {
    enable = true,
    disable = { "" },
    additional_vim_regex_highlighting = false     -- Don't use vim regex for faster performance
  },
  indent = {
    enable = true,
    disable = { "" }
  }
})

require('ts_context_commentstring').setup({
  enable_autocmd = false
})
