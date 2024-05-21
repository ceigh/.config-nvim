return {
  "https://github.com/terrortylor/nvim-comment",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "<leader>cc", ":CommentToggle<CR>",      silent = true },
    { "<leader>c",  ":'<,'>CommentToggle<CR>", mode = "v",   silent = true },
  },
  main = "nvim_comment",

  opts = {
    comment_empty = false,
    create_mappings = false,

    hook = function()
      require("ts_context_commentstring.internal").update_commentstring()
    end,
  },
}
