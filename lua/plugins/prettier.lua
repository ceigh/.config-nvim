local ft = {
  "html",
  "vue",
  "css",
  "scss",
  "typescript",
  "javascript",
  "json",
  "jsonc",
  "yaml",
  "graphql",
  "markdown",
}

return {
  "https://github.com/MunifTanjim/prettier.nvim",
  dependencies = {
    "jose-elias-alvarez/null-ls.nvim",
  },
  event = "BufWritePre",
  ft = ft,

  config = function()
    local fmt_on_save = require("utils").lsp.fmt_on_save

    require("null-ls").setup({
      on_attach = function(_, bufnr) fmt_on_save(bufnr) end,
    })

    require("prettier").setup({
      bin = 'prettierd',
      filetypes = ft,
    })
  end,
}
