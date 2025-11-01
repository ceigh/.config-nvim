local M = {}

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

return M
