local lspconfig = require("lspconfig")
local cmp = require("cmp")

-- Completion
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

local function get_typescript_server_path(root_dir)
  local global_ts = "/Users/hcg/.config/yarn/global/node_modules/typescript/lib"
  local found_ts = ""
  local function check_dir(path)
    found_ts =
        lspconfig.util.path.join(path, "node_modules", "typescript", "lib")
    if lspconfig.util.path.exists(found_ts) then
      return path
    end
  end

  if lspconfig.util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

-- Default config
lspconfig.util.default_config =
    vim.tbl_deep_extend("force", lspconfig.util.default_config, {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      ---@diagnostic disable-next-line: unused-local
      on_attach = function(client, bufnr)
        set_mappings()
        create_format_on_save_au(bufnr)
      end
    })
lspconfig.util.default_config
.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- Configurations
lspconfig.volar.setup {
  on_attach = function(client)
    set_mappings()
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
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    set_mappings()
    create_format_on_save_au(bufnr, function() vim.cmd "EslintFixAll" end)
  end,
  filetypes = { "javascript", "typescript", "vue" },
}

lspconfig.stylelint_lsp.setup {
  filetypes = { "css", "scss", "vue" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
}

lspconfig.graphql.setup {}

lspconfig.lua_ls.setup {
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

lspconfig.gopls.setup {}

lspconfig.elixirls.setup {
  cmd = { "/opt/homebrew/bin/elixir-ls" },
}

lspconfig.gleam.setup {}
