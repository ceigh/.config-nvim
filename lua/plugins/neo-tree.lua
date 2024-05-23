return {
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "\\", ":Neotree reveal float toggle<CR>", silent = true },
  },

  opts = {
    enable_diagnostics = false,
    popup_border_style = "rounded",

    default_component_configs = {
      container = {
        enable_character_fade = false,
      },
      icon = {
        folder_closed = "+",
        folder_open = "-",
        folder_empty = "~",
      },
      modified = { symbol = "" },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "",
          unstaged = "",
          staged = "",
          conflict = "",
          ignored = "^",
        },
      },
    },
  },
}
