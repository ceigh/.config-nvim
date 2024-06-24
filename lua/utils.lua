-- local home = os.getenv("HOME") .. "/"
-- local bun_path = home .. ".bun/"
local brew_path = "/opt/homebrew/"

return {
  map_key = function(l, r, mode, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true

    vim.keymap.set(mode or "n", l, r, opts)
  end,

  paths = {
    -- bun = bun_path,
    -- bun_modules = bun_path .. "install/global/node_modules/",
    -- brew = brew_path,
    brew_bin = brew_path .. "bin",
  },
}
