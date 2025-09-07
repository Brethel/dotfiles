local icons = {
	-- Change type
	added = "✚",
	modified = "○",
	deleted = "✖",
	renamed = "󰁕",
	-- Status type
	untracked = "",
	ignored = " ",
	unstaged = "󰄱 ",
	staged = "󰱒 ",
	conflict = " ",
	-- Snacks
	commit = "󰜘",
	unmerged = " ",
}

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			signs = {
				add = { text = icons.added },
				change = { text = icons.modified },
				delete = { text = icons.deleted },
				topdelete = { text = icons.deleted },
				changedelete = { text = icons.modified },
				untracked = { text = icons.untracked },
			},
			signs_staged = {
				add = { text = icons.added },
				change = { text = icons.deleted },
				delete = { text = icons.deleted },
				topdelete = { text = icons.deleted },
				changedelete = { text = icons.modified },
				untracked = { text = icons.untracked },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align", -- "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			-- yadm = {
			-- 	enable = false,
			-- },
		})
	end,
}
