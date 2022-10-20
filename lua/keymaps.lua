local map_key = require("utils").map_key

vim.g.mapleader = ","

map_key("", "<up>", "<nop>")
map_key("", "<down>", "<nop>")
map_key("", "<left>", "<nop>")
map_key("", "<right>", "<nop>")
map_key("n", ";", ":noh<CR>")
