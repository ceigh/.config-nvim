local colorcolumn = require("utils").colorcolumn

vim.o.colorcolumn = ""

require("virt-column").setup {
  virtcolumn = colorcolumn,
  char = "│",
}
