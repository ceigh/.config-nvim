return {
  "https://github.com/neovim/nvim-lspconfig",
  dependencies = {
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "dcampos/nvim-snippy",
        "dcampos/cmp-snippy",
      },
    },
    {
      "MunifTanjim/prettier.nvim",
      dependencies = {
        "jose-elias-alvarez/null-ls.nvim",
      },
    },
    {
      "Exafunction/codeium.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      }
    }
  },
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lspconfig = require("lspconfig")
    local paths = require("utils").paths

    -- Appearance

    -- LSP
    vim.diagnostic.config {
      virtual_text = false,
      update_in_insert = false,
    }

    -- Hover window opts
    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
          max_width = 60,
        })

    -- Helpers

    local function fmt_on_save(buffer, callback)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = callback or function() vim.lsp.buf.format() end,
      })
    end

    local function disable_fmt(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    local function get_typescript_server_path(root_dir)
      local global_ts =
          paths.bun .. "install/global/node_modules/typescript/lib"
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
          on_attach = function(_, bufnr)
            fmt_on_save(bufnr)
          end
        })
    lspconfig.util.default_config.capabilities.workspace
    .didChangeWatchedFiles.dynamicRegistration = true

    -- Configurations

    lspconfig.volar.setup {
      on_attach = function(client) disable_fmt(client) end,
      filetypes = { "typescript", "javascript", "vue", "json", "css", "scss" },
      -- Use local typescript and fallback to global
      on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk =
            get_typescript_server_path(new_root_dir)
      end,
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    }

    lspconfig.eslint.setup {
      on_attach = function(_, bufnr)
        fmt_on_save(bufnr, function() vim.cmd "EslintFixAll" end)
      end,
      filetypes = {
        "javascript",
        "typescript",
        "vue",
        "html",
        "css",
        "scss",
        "markdown",
        -- "json",
        -- "jsonc",
      },
    }

    lspconfig.stylelint_lsp.setup {
      filetypes = { "css", "scss", "vue" },
      settings = {
        stylelintplus = {
          autoFixOnFormat = true,
        },
      },
    }

    require 'lspconfig'.lua_ls.setup {
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or
            vim.loop.fs_stat(path .. '/.luarc.jsonc') then
          return
        end

        client.config.settings.Lua =
            vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = { version = 'LuaJIT' },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME }
              }
            })
      end,
      settings = {
        Lua = {}
      }
    }

    -- lspconfig.unocss.setup {}

    lspconfig.graphql.setup {}

    lspconfig.gleam.setup {}

    lspconfig.gopls.setup {}

    lspconfig.elixirls.setup {
      cmd = { paths.brew .. "elixir-ls" },
    }

    -- Prettier
    require("null-ls").setup {
      on_attach = function(_, bufnr) fmt_on_save(bufnr) end,
    }
    require("prettier").setup {
      bin = 'prettierd',
      filetypes = {
        "html",
        "vue",
        "css",
        "scss",
        -- "typescript",
        "javascript",
        "json",
        "yaml",
        "graphql",
        "markdown",
      },
    }

    -- Hotkeys
    local map_key = require("utils").map_key
    map_key("[d", vim.diagnostic.goto_prev)
    map_key("]d", vim.diagnostic.goto_next)
    map_key("<leader>a", vim.lsp.buf.code_action)
    map_key("<leader>r", vim.lsp.buf.rename)
    map_key("gd", vim.lsp.buf.definition)
    map_key("gi", vim.lsp.buf.implementation)
    map_key("<leader>f", vim.lsp.buf.format)

    -- Completion

    local cmp = require("cmp")
    local cmp_window_opts = { scrollbar = false }

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(cmp_window_opts),
        documentation = cmp.config.window.bordered(cmp_window_opts)
      },
      performance = {
        max_view_entries = 32,
      },
      completion = {
        keyword_length = 2,
      },
      experimental = {
        ghost_text = true,
      },

      formatting = {
        expandable_indicator = false,
        format = function(_, vim_item)
          local label = vim_item.abbr
          local truncated_label = vim.fn.strcharpart(label, 0, 16)
          if truncated_label ~= label then
            vim_item.abbr = truncated_label .. "…"
          end
          vim_item.menu = nil
          return vim_item
        end,
      },

      snippet = {
        expand = function(args)
          require("snippy").expand_snippet(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-z>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
        { name = "codeium", max_item_count = 4 },
      }, {
        { name = "buffer" },
        { name = "path" },
      })
    })

    -- Codeium
    require("codeium").setup({})
  end,
}
