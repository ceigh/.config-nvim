-- https://github.com/savq/melange-nvim

return {
  "savq/melange",
  lazy = false,
  priority = 1000,
  config = function() vim.cmd("colorscheme melange") end
}
