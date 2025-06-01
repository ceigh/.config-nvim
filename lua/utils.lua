local brew_path = "/opt/homebrew/"

return {
	paths = {
		brew_bin = brew_path .. "bin",
	},

	map_key = function(l, r, mode, opts)
		opts = opts or {}
		opts.noremap = true
		opts.silent = true

		vim.keymap.set(mode or "n", l, r, opts)
	end,

	lsp = {
		fmt_on_save = function(buffer, callback)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = buffer,
				callback = callback or function()
					vim.lsp.buf.format()
				end,
			})
		end,
	},
}
