-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  lazy = vim.fn.argc(-1) == 0,
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup {
      modules = {},
      highlight = { enable = true },
      indent = { enable = true },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      ensure_installed = {
        "bash",
        "comment",
        "css",
        "git_config",
        "gitattributes",
        "gitignore",
        "go",
        "graphql",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "make",
        "markdown",
        "scss",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "gleam",
      },
    }
  end,
}
