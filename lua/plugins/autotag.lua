-- https://github.com/windwp/nvim-ts-autotag

return {
  "windwp/nvim-ts-autotag",
  event = "VeryLazy",
  lazy = vim.fn.argc(-1) == 0,
  config = true,
}
