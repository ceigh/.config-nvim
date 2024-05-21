local map_key = require("utils").map_key

return {
  "https://github.com/lewis6991/gitsigns.nvim",
  event = "VeryLazy",

  opts = {
    on_attach = function()
      local gitsigns = require("gitsigns")

      -- Nav
      map_key(
        "]g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]g", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end
      )
      map_key(
        "[g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[g", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end
      )

      -- Hunks
      map_key("<leader>hr", gitsigns.reset_hunk)
      map_key(
        "<leader>hr",
        function()
          gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
        end,
        "v"
      )
      map_key("<leader>hp", gitsigns.preview_hunk)
    end
  }
}
