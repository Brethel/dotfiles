--
-- general keymaps ( plugins will have their keymaps on their own files )
--
kmap({ "n", "i" }, "<C-s>", "<cmd>w!<CR>", { desc = "save file" })
kmap({ "n", "i" }, "<C-z>", "<cmd>undo<CR>", { desc = "undo" })
kmap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "No Highlight search" })
kmap("n", "<leader>Q", "<cmd>wallq!<CR>", { desc = "Force save and  quit" })
kmap("n", "<leader>HH", "<cmd>silent vert bo help<cr>", { desc = "Vertical help" })

-- Stay in indent mode.
kmap("v", "<", "<gv", { desc = "Visual Outdent" })
kmap("v", ">", ">gv", { desc = "Visual Indent" })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
kmap({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
kmap({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })

--  Folding commands.
-- Author: Karl Yngve Lervåg
--    See: https://github.com/lervag/dotnvim
-- Close all fold except the current one.
kmap("n", "zv", "zMzvzz", { desc = "Close all folds except current" })
-- Close current fold when open. Always open next fold.
kmap("n", "zj", "zcjzOzz", { desc = "Close fold & open next one" })
-- Close current fold when open. Always open previous fold.
kmap("n", "zk", "zckzOzz", { desc = "Close fold & open previous one" })
kmap("n", "zT", function()
	local get_opt = vim.api.nvim_win_get_option
	local set_opt = vim.api.nvim_win_set_option

	if get_opt(0, "foldlevel") >= 20 then
		set_opt(0, "foldlevel", 0)
	else
		set_opt(0, "foldlevel", 20)
	end
end, { desc = "Toggle All Folding" })

--  Keep the cursor in place while joining lines.
kmap("n", "J", "mzJ`z", { desc = "Join lines" })
kmap("n", "<leader>J", "myvipJ`ygq<cr>", { desc = "Join Paragraph" })

-- split/navigate panes
kmap("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
kmap("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
kmap("n", "<C-k>", "<c-w>k")
kmap("n", "<C-j>", "<c-w>j")
kmap("n", "<C-h>", "<c-w>h")
kmap("n", "<C-l>", "<c-w>l")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
kmap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
