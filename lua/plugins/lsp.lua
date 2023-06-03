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

local function create_format_on_save_au(buffer, callback)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = buffer,
    callback = callback or function() vim.lsp.buf.format() end,
  })
end

local function on_attach()
  set_mappings()
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local util = lspconfig.util

local function get_typescript_server_path(root_dir)
  local global_ts = "/Users/hcg/.config/yarn/global/node_modules/typescript/lib"
  local found_ts = ""
  local function check_dir(path)
    found_ts = util.path.join(path, "node_modules", "typescript", "lib")
    if util.path.exists(found_ts) then
      return path
    end
  end

  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

-- Configurations
lspconfig.volar.setup {
  capabilities = capabilities,
  on_attach = function(client)
    on_attach()
    -- disable formatting due to stylelint_lsp format on save
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes = {
    "typescript",
    "javascript",
    -- "javascriptreact",
    -- "typescriptreact",
    "vue",
    "json",
    "css",
    "scss",
  },
  -- Use local typescript and fallback to global
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk =
        get_typescript_server_path(new_root_dir)
  end,
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach()
    create_format_on_save_au(bufnr, function() vim.cmd "EslintFixAll" end)
  end,
  filetypes = { "javascript", "typescript", "vue" },
}

lspconfig.stylelint_lsp.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach()
    create_format_on_save_au(bufnr)
  end,
  filetypes = { "css", "scss", "vue" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
}

-- volar used instead
-- for completions
-- lspconfig.cssls.setup {
--   capabilities = capabilities,
--   filetypes = { "css", "scss" },
--   settings = {
--     -- validation via stylelint
--     css = { validate = false },
--     scss = { validate = false }
--   }
-- }

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach()
    create_format_on_save_au(bufnr)
  end,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach()
    create_format_on_save_au(bufnr)
  end,
}

lspconfig.elixirls.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach()
    create_format_on_save_au(bufnr)
  end,
  cmd = { "/opt/homebrew/bin/elixir-ls" },
}
