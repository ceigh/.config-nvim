local M = {}

M.VERTICAL_BAR_CHAR = "│"

M.FLOAT_MAX_WIDTH = 64
M.FLOAT_MAX_HEIGHT = 32

function M.filter_markdown_content(contents)
	local function process_text(text)
		if not text then
			return text
		end

		-- Remove image markdown (especially data:image)
		text = text:gsub("!%[.-%]%(data:image/[^%)]+%)", "")

		-- Remove markdown escape characters
		text = text:gsub("\\([%.%{%}%[%]%(%)%*%+%-%#%!%|%~%`%_%^])", "%1")

		-- Remove excessive newlines
		text = text:gsub("\n\n\n+", "\n\n")

		return text
	end

	-- Handle MarkedString format (LSP)
	if type(contents) == "table" and contents.kind == "markdown" then
		contents.value = process_text(contents.value)
	-- Handle array of strings
	elseif type(contents) == "table" then
		for i, line in ipairs(contents) do
			contents[i] = process_text(line)
		end
	-- Handle plain string
	elseif type(contents) == "string" then
		contents = process_text(contents)
	end

	return contents
end

-- Cast Typograf on visual selection
function M.typograf_selection()
	local mt = vim.fn.visualmode()
	if mt == "\22" then
		vim.notify(
			"typograf_selection: blockwise selection not supported",
			vim.log.levels.WARN
		)
		return
	end

	local pos_start = vim.fn.getpos("'<")
	local pos_end = vim.fn.getpos("'>")

	local input = vim.fn.getregion(pos_start, pos_end, { type = mt })

	local output = vim.fn.systemlist({
		"typograf",
		"--stdin",
		"--locale",
		"ru,en-US",
		"--html-entity-type",
		"name",
		"--html-entity-only-invisible",
		"--no-color",
	}, input)

	if #output == 0 then
		output = { "" }
	end

	if mt == "V" then
		local start_row = pos_start[2] - 1
		local end_row = pos_end[2]
		vim.api.nvim_buf_set_lines(0, start_row, end_row, true, output)
		return
	end

	-- charwise (v)
	local start_row = pos_start[2] - 1
	local start_col = pos_start[3] - 1

	local end_row = pos_end[2] - 1
	local end_line =
		vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1]
	local end_col_inclusive = pos_end[3]
	local end_col = vim.fn.byteidx(
		end_line,
		vim.fn.charidx(end_line, end_col_inclusive - 1) + 1
	)
	if end_col == -1 then
		end_col = #end_line
	end

	vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, output)
end

return M
