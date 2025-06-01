return {
	fmt_on_save = function(buffer, callback)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = buffer,
			callback = callback or function()
				vim.lsp.buf.format()
			end,
		})
	end,
}
