return {
	"https://github.com/neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local lspconfig = require("lspconfig")
		local utils = require("utils")
		local paths = utils.paths

		-- Helpers

		local fmt_on_save = utils.lsp.fmt_on_save

		local function disable_fmt(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		-- Default config
		lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(_, bufnr)
				fmt_on_save(bufnr)
			end,
		})
		lspconfig.util.default_config.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

		-- Configurations

		lspconfig.volar.setup({
			on_attach = function(client)
				disable_fmt(client)
			end,
			filetypes = {
				"javascript",
				"typescript",
				"vue",
				"css",
				"scss",
			},
			init_options = {
				vue = {
					hybridMode = false,
				},
			},
		})

		lspconfig.eslint.setup({
			on_attach = function(_, bufnr)
				fmt_on_save(bufnr, function()
					vim.cmd("EslintFixAll")
				end)
			end,
			filetypes = {
				"javascript",
				"typescript",
				"vue",

				-- Only if eslint stylistic supported by project
				"html",
				"css",
				"scss",
				"markdown",
				-- "json",
				-- "jsonc",
			},
		})

		lspconfig.stylelint_lsp.setup({
			settings = {
				stylelintplus = {
					autoFixOnFormat = true,
				},
			},
			filetypes = {
				"css",
				"scss",
				"vue",
			},
		})

		require("lspconfig").lua_ls.setup({
			on_attach = function(client, bufnr)
				disable_fmt(client)
				fmt_on_save(bufnr, function()
					require("stylua-nvim").format_file()
				end)
			end,

			on_init = function(client)
				local path = client.workspace_folders[1].name
				---@diagnostic disable-next-line: undefined-field
				if
					---@diagnostic disable-next-line: undefined-field
					vim.loop.fs_stat(path .. "/.luarc.json")
					---@diagnostic disable-next-line: undefined-field
					or vim.loop.fs_stat(path .. "/.luarc.jsonc")
				then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = { version = "LuaJIT" },
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME },
					},
				})
			end,

			settings = { Lua = {} },
		})

		-- lspconfig.unocss.setup({})

		lspconfig.graphql.setup({})

		lspconfig.gleam.setup({})

		lspconfig.gopls.setup({})

		lspconfig.elixirls.setup({
			cmd = { paths.brew_bin .. "elixir-ls" },
		})

		-- Appearance

		-- LSP
		vim.diagnostic.config({
			virtual_text = false,
			update_in_insert = false,
			float = {
				border = "rounded",
				max_width = 60,
			},
		})

		-- Hover window opts
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = 60,
		})

		-- Hotkeys
		local map_key = require("utils").map_key
		map_key("[d", vim.diagnostic.goto_prev)
		map_key("]d", vim.diagnostic.goto_next)
		map_key("<leader>a", vim.lsp.buf.code_action)
		map_key("<leader>r", vim.lsp.buf.rename)
		map_key("gd", vim.lsp.buf.definition)
		map_key("gi", vim.lsp.buf.implementation)
		map_key("<leader>f", vim.lsp.buf.format)
	end,
}
