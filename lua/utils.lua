local M = {}

function M.map_key(mode, key, result, opts)
  vim.keymap.set(
    mode,
    key,
    result,
    opts or { noremap = true, silent = true }
  )
end

return M
