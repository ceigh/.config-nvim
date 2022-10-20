-- Completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("snippy").expand_snippet(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- ["<C-X>"] = cmp.mapping.complete(),
    ["<C-z>"] = cmp.mapping.complete(),
    ["<C-x>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "snippy" },
  }, {
    { name = "buffer" },
    { name = "path" },
  })
})

-- Appearance
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
}
)

-- Helpers
local map_key = require("utils").map_key
local function set_mappings()
  map_key("n", "[d", vim.diagnostic.goto_prev)
  map_key("n", "]d", vim.diagnostic.goto_next)
  map_key("n", "<leader>a", vim.lsp.buf.code_action)
  map_key("n", "<leader>r", vim.lsp.buf.rename)
  map_key("n", "gd", vim.lsp.buf.definition)
  map_key("n", "gi", vim.lsp.buf.implementation)
  map_key("n", "<leader>f", vim.lsp.buf.format)
end

local function create_format_on_save_au(name, pattern, callback)
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = pattern,
    callback = callback or function() vim.lsp.buf.format() end,
    group = vim.api.nvim_create_augroup(name .. "_on_save", {}),
  })
end

local function on_attach()
  set_mappings()
end

-- Configurations
local capabilities = require("cmp_nvim_lsp")
    .update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")

lspconfig.volar.setup {
  capabilities = capabilities,
  on_attach = function()
    on_attach()
  end,
  filetypes = {
    "typescript",
    "javascript",
    -- "javascriptreact",
    -- "typescriptreact",
    "vue",
    "json",
  },
}

lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = function()
    on_attach()
    create_format_on_save_au("sumneko_lua", { "*.lua" })
  end,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  on_attach = function()
    on_attach()
    create_format_on_save_au(
      "eslint",
      -- see ft below
      { "*.js", "*.ts", "*.vue" },
      function() vim.cmd "EslintFixAll" end
    )
  end,
  filetypes = { "javascript", "typescript", "vue", "json" },
}

lspconfig.stylelint_lsp.setup {
  capabilities = capabilities,
  on_attach = function()
    on_attach()
    create_format_on_save_au(
      "stylelint_lsp",
      -- see ft below
      { "*.css", "*.scss", "*.vue" }
    )
  end,
  filetypes = { "css", "scss", "vue" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
}
