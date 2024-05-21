return {
  "https://github.com/norcalli/nvim-colorizer.lua",
  event = "BufEnter",
  lazy = vim.fn.argc(-1) == 0,
  opts = { "*" },
}
