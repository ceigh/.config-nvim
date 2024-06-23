return {
  enabled = false,
  "https://github.com/savq/melange-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme melange")
  end
}
