-- Vue specific completion filters, see
-- https://github.com/vuejs/language-tools/discussions/4495

local M = {}

function M.is_in_start_tag()
	local ts_utils = require("nvim-treesitter.ts_utils")

	local node = ts_utils.get_node_at_cursor()
	if not node then
		return false
	end

	local node_to_check = {
		"start_tag",
		"self_closing_tag",
		"directive_attribute",
	}

	return vim.tbl_contains(node_to_check, node:type())
end

function M.vue_entry_filter(entry, ctx)
	-- Check if the buffer type is 'vue'
	if ctx.filetype ~= "vue" then
		return true
	end

	-- Use a buffer-local variable to cache the result of the Treesitter check
	local bufnr = ctx.bufnr

	local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
	if cached_is_in_start_tag == nil then
		vim.b[bufnr]._vue_ts_cached_is_in_start_tag = M.is_in_start_tag()
	end

	-- If not in start tag, return true
	if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
		return true
	end

	local cursor_before_line = ctx.cursor_before_line

	-- For events
	if cursor_before_line:sub(-1) == "@" then
		return entry.completion_item.label:match("^@")
	end

	-- For props also exclude events with `:on-` prefix
	if cursor_before_line:sub(-1) == ":" then
		return entry.completion_item.label:match("^:") and not entry.completion_item.label:match("^:on%-")
	end

	return true
end

return M
