return {
  "https://github.com/savq/melange-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme melange")

    local hl = vim.api.nvim_set_hl
    hl(0, "Search", { bg = "#fae55c", fg = "#000000" })
    hl(0, "CurSearch", { link = "Search" })
    hl(0, "IncSearch", { link = "Search" })
  end
}
