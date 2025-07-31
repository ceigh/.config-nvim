return {
	"https://github.com/neovim/nvim-lspconfig",
	version = "^2.4.0",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"https://github.com/mason-org/mason-lspconfig.nvim",
			version = "^2.0.0",
			dependencies = {
				"https://github.com/mason-org/mason.nvim",
				version = "^2.0.0",
				keys = {
					{ "<leader>M", ":Mason<CR>", silent = true },
				},
			},
		},
		"https://github.com/b0o/SchemaStore.nvim",
		"https://github.com/nvimtools/none-ls.nvim",
		"https://github.com/MunifTanjim/prettier.nvim",
	},

	config = function()
		----------------
		-- Appearance --
		----------------

		vim.diagnostic.config({
			-- Show float on diagnostic navigation
			jump = {
				float = true,
			},
		})

		-------------
		-- Keymaps --
		-------------

		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

		vim.keymap.set("n", "gd", function()
			vim.cmd("tab split")
			vim.lsp.buf.definition()
		end)

		vim.keymap.set("n", "gi", function()
			vim.cmd("tab split")
			vim.lsp.buf.implementation()
		end)

		------------------------
		-- Native completions --
		------------------------

		-- vim.api.nvim_create_autocmd("LspAttach", {
		-- 	callback = function(event)
		-- 		local client = vim.lsp.get_client_by_id(event.data.client_id)
		--
		-- 		if client ~= nil then
		-- 			if client:supports_method("textDocument/completion") then
		-- 				vim.lsp.completion.enable(true, client.id, event.buf, {
		-- 					autotrigger = true,
		-- 				})
		-- 			end
		-- 		end
		-- 	end,
		-- })
		--
		-- vim.keymap.set("i", "<C-z>", function()
		-- 	vim.lsp.completion.get()
		-- end)
		--
		-- vim.keymap.set("i", "<Tab>", function()
		-- 	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
		-- end, { expr = true })
		--
		-- vim.keymap.set("i", "<S-Tab>", function()
		-- 	return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
		-- end, { expr = true })

		-------------
		-- Helpers --
		-------------

		local function fmt_on_save(client, buffer, callback)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = buffer,

				callback = callback or function()
					if client.supports_method("textDocument/formatting") then
						vim.lsp.buf.format()
					end
				end,
			})
		end

		local function disable_builtin_fmt(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		--------------------
		-- Configurations --
		--------------------

		-- Default config
		vim.lsp.config("*", {
			on_attach = function(client, buffer)
				fmt_on_save(client, buffer)
			end,
		})

		-- Provides LspEslintFixAll
		local eslint_on_attach = vim.lsp.config.eslint.on_attach

		vim.lsp.config("eslint", {
			on_attach = function(client, buffer)
				disable_builtin_fmt(client)

				if not eslint_on_attach then
					return
				end

				eslint_on_attach(client, buffer)

				fmt_on_save(client, buffer, function()
					vim.cmd("silent! LspEslintFixAll")
				end)
			end,

			filetypes = {
				"javascript",
				"typescript",
				"vue",

				-- "html",
				-- "markdown",
				-- "json",
				-- "jsonc",
				-- "yaml",
				-- "gql",
				-- "graphql",
				-- "css",
				-- "scss",
			},
		})

		vim.lsp.config("oxlint", {
			on_attach = function(client, buffer)
				-- Getting back missing autofix function after 0.11 migration
				-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/oxlint.lua#L20
				fmt_on_save(client, buffer, function()
					-- local client = vim.lsp.get_clients({
					-- 	bufnr = 0,
					-- 	name = "oxlint",
					-- })[1]

					-- if client == nil then
					-- 	return
					-- end

					---@diagnostic disable-next-line: param-type-mismatch
					client.request("workspace/executeCommand", {
						command = "oxc.fixAll",
						arguments = { { uri = vim.uri_from_bufnr(0) } },
						---@diagnostic disable-next-line: param-type-mismatch
					}, nil, 0)
				end)
			end,

			filetypes = {
				"javascript",
				"typescript",
				"vue",
			},
		})

		vim.lsp.config("stylelint_lsp", {
			settings = {
				stylelintplus = {
					autoFixOnFormat = true,
				},
			},
		})

		vim.lsp.config("cssls", {
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,
		})

		vim.lsp.config("tailwindcss", {
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,

			settings = {
				tailwindCSS = {
					classFunctions = { "cva", "cn" },
				},
			},
		})

		-- https://github.com/vuejs/language-tools/wiki/Neovim

		vim.lsp.config("vtsls", {
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,

			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages"
									.. "/vue-language-server/node_modules/@vue/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
							},
						},
					},
				},
			},

			filetypes = {
				"typescript",
				"javascript",
				"vue",
			},
		})

		vim.lsp.config("vue_ls", {
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,
		})

		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					schemas = require("schemastore").yaml.schemas(),
					schemaStore = {
						-- To use schemaStore plugin
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined
						-- (reading 'length')
						url = "",
					},
				},
			},
		})

		vim.lsp.config("lua_ls", {
			on_attach = function(client, _)
				disable_builtin_fmt(client)
			end,

			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name

					if
						path ~= vim.fn.stdpath("config")
						---@diagnostic disable-next-line: undefined-field
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
						-- Tell the language server how to find Lua modules same way as
						-- Neovim (see `:h lua-module-load`)
						path = {
							"lua/?.lua",
							"lua/?/init.lua",
						},
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME },
					},
				})
			end,

			settings = { Lua = {} },
		})

		----------------------
		-- Install binaries --
		----------------------

		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_enable = false,
			ensure_installed = {
				"eslint",
				"oxlint",
				"stylelint_lsp",
				"cssls",
				"css_variables",
				"unocss",
				"tailwindcss",
				"vtsls",
				"vue_ls@3.0.0",
				"graphql",
				"lua_ls",
				"jsonls",
				"yamlls",
				"taplo",
				"prismals",
				"bashls",
			},
		})

		------------
		-- Enable --
		------------

		vim.lsp.enable({
			"eslint",
			"oxlint",
			"stylelint_lsp",
			"cssls",
			"css_variables",
			"unocss",
			"tailwindcss",
			"graphql",
			"lua_ls",
			"vtsls",
			"vue_ls",
			"stylua3p_ls",
			"jsonls",
			"yamlls",
			"taplo",
			"prismals",
			"bashls",
		})

		------------
		-- Custom --
		------------

		require("null-ls").setup({
			on_attach = function(client, buffer)
				fmt_on_save(client, buffer)
			end,
		})

		require("prettier").setup({
			bin = "prettierd",
			filetypes = {
				"html",
				"vue",
				"css",
				"scss",
				"typescript",
				"javascript",
				"json",
				"jsonc",
				"yaml",
				"graphql",
				"markdown",
			},
		})
	end,
}
