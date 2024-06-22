local home = os.getenv("HOME") .. "/"

return {
  map_key = function(l, r, mode, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true

    vim.keymap.set(mode or "n", l, r, opts)
  end,

  paths = {
    bun = home .. ".bun/",
    brew = "/opt/homebrew/bin/",
  },
}
