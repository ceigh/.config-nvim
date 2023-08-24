local map_key = require("utils").map_key

map_key("n", "\\", ":Neotree reveal float toggle<CR>")

-- https://github.com/nvim-neo-tree/neo-tree.nvim#longer-example-for-packer
require("neo-tree").setup {
  enable_diagnostics = false,

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
      }
    },
  },
}
