local map_key = require("utils").map_key

require("gitsigns").setup {
  on_attach = function()
    local gs = package.loaded.gitsigns

    -- Navigation
    map_key('n', ']g', function()
      if vim.wo.diff then return ']g' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, silent = true, noremap = true })

    map_key('n', '[g', function()
      if vim.wo.diff then return '[g' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, silent = true, noremap = true })

    -- Actions
    map_key({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map_key('n', '<leader>hp', gs.preview_hunk)
  end
}
