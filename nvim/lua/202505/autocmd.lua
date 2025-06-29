-- Create autogroup.

local function is_lazyvim_loaded()
	if pcall(require, "lazyvim") then
		return true
	else
		return false
	end
end

local function augroup(name)
	local agName = "traap_"
	if is_lazyvim_loaded() then
		agName = "lazyvim_"
	end
	return vim.api.nvim_create_augroup(agName .. name, { clear = true })
end

-- {{{ Go to last location when opening a buffer

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- {{{ Highlight on yank

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- {{{ Remove trailing WhiteSpace

vim.api.nvim_create_autocmd("BufWritePre", {
	command = [[%s/\s\+$//e]],
	group = augroup("whitespace"),
})
