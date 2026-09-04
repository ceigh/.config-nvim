local utils = require("utils")

---@type LazySpec
return {
	"https://github.com/neovim/nvim-lspconfig",
	version = "^2.7.0",
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
				on_jump = function(diagnostic, bufnr)
					if diagnostic then
						vim.diagnostic.open_float({
							bufnr = bufnr,
							scope = "cursor",
							focus = false,
						})
					end
				end,
			},
			-- virtual_text = {
			-- 	spacing = 1,
			-- },
			severity_sort = true,
			float = {
				border = "rounded",
				-- source = "if_many",
				max_width = utils.FLOAT_MAX_WIDTH,
				max_height = utils.FLOAT_MAX_HEIGHT,
			},
		})

		-- Hover window appearance
		local orig_util_open_floating_preview =
			vim.lsp.util.open_floating_preview
		---@diagnostic disable-next-line: duplicate-set-field
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.max_width = opts.max_width or utils.FLOAT_MAX_WIDTH
			opts.max_height = opts.max_height or utils.FLOAT_MAX_HEIGHT
			-- Filter markdown output
			contents = utils.filter_markdown_content(contents)
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

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
					if client:supports_method("textDocument/formatting") then
						vim.lsp.buf.format({
							timeout_ms = 3000,
						})
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

		-- ESLint
		-- A smart setup for both legacy and modern projects. Flat-config projects
		-- also format css, html, etc; legacy projects handle only js, ts and vue.

		local legacy_eslint_filetypes = {
			javascript = true,
			typescript = true,
			vue = true,
		}

		local flat_eslint_filetypes =
			vim.tbl_extend("force", vim.deepcopy(legacy_eslint_filetypes), {
				html = true,
				markdown = true,
				json = true,
				jsonc = true,
				yaml = true,
				gql = true,
				graphql = true,
				css = true,
				scss = true,
				toml = true,
			})

		local legacy_eslint_config_files = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
		}

		local flat_eslint_config_files = {
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
		}

		local eslint_config_files = vim.list_extend(
			vim.deepcopy(flat_eslint_config_files),
			legacy_eslint_config_files
		)

		local function get_eslint_root(bufnr)
			local filename = vim.api.nvim_buf_get_name(bufnr)

			if filename == "" then
				return nil
			end

			local found = vim.fs.find(eslint_config_files, {
				path = filename,
				upward = true,
				type = "file",
				limit = 1,
			})

			if not found[1] then
				return nil
			end

			return vim.fs.dirname(found[1])
		end

		local function has_flat_eslint_config(root)
			for _, filename in ipairs(flat_eslint_config_files) do
				if vim.uv.fs_stat(root .. "/" .. filename) then
					return true
				end
			end

			return false
		end

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

			filetypes = vim.tbl_keys(flat_eslint_filetypes),

			root_dir = function(bufnr, on_dir)
				local root = get_eslint_root(bufnr)
				if not root then
					return
				end

				local filetype = vim.bo[bufnr].filetype

				-- Flat eslint
				if has_flat_eslint_config(root) then
					if flat_eslint_filetypes[filetype] then
						on_dir(root)
					end
					return
				end

				-- Legacy eslint
				if legacy_eslint_filetypes[filetype] then
					on_dir(root)
				end
			end,
		})

		-- Old lsp server https://github.com/bmatcuk/stylelint-lsp for old projects
		vim.lsp.config("stylelint_lsp_legacy", {
			cmd = { "stylelint-lsp", "--stdio" },
			filetypes = {
				"css",
				"scss",
				"vue",
			},
			root_markers = {
				".stylelintrc",
				".stylelintrc.json",
				".stylelintrc.yaml",
				".stylelintrc.yml",
				".stylelintrc.js",
				".stylelintrc.cjs",
				".stylelintrc.mjs",
				"stylelint.config.js",
				"stylelint.config.cjs",
				"stylelint.config.mjs",
				"package.json",
			},

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
					validate = false,
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
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,

			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("yamlls", {
			on_attach = function(client)
				disable_builtin_fmt(client)
			end,

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
				"oxfmt",
				"cssls",
				"css_variables",
				"unocss",
				"tailwindcss",
				"vtsls",
				"vue_ls@3.0.8",
				"graphql",
				"lua_ls@3.16.4",
				"jsonls",
				"yamlls",
				"taplo",
				"prismals",
				"bashls",
				"dockerls",
				"docker_compose_language_service",
				"nginx_language_server",
			},
		})

		------------
		-- Enable --
		------------

		vim.lsp.enable({
			"eslint",
			"oxlint",
			"oxfmt",
			"stylelint_lsp_legacy",
			"cssls",
			-- "css_variables",
			-- "unocss",
			-- "tailwindcss",
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
			"dockerls",
			"docker_compose_language_service",
			"nginx_language_server",
		})

		------------
		-- Custom --
		------------

		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- nginxfmt
				{
					method = null_ls.methods.FORMATTING,
					filetypes = { "nginx" },
					generator = require("null-ls.helpers").formatter_factory({
						command = "nginxfmt",
						args = { "-" },
						to_stdin = true,
					}),
				},

				-- caddy
				{
					method = null_ls.methods.FORMATTING,
					filetypes = { "caddyfile" },
					generator = require("null-ls.helpers").formatter_factory({
						command = "caddy",
						args = { "fmt", "-" },
						to_stdin = true,
					}),
				},

				-- pint (php)
				null_ls.builtins.formatting.pint,

				-- hado (dockerfile)
				null_ls.builtins.diagnostics.hadolint,
			},

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
