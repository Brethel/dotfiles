return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false, -- make sure we load this during startup
		priority = 1000, -- load before all other plugins
		config = function()
			-- Load gruvbox with custom settings
			require("gruvbox").setup({
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					comments = true,
					keywords = true,
					functions = false,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "hard", -- can be "hard", "soft" or empty string
				overrides = {
					SignColumn = { bg = "#1d2021" },
					ColorColumn = { bg = "#3c3836" },
				},
				dim_inactive = false,
				transparent_mode = false, -- set to true for transparent background
			})

			-- Set colorscheme after options
			vim.cmd("colorscheme gruvbox")

			-- Custom highlight groups for better Gruvbox integration
			vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true, fg = "#fe8019" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#665c54" })
			vim.api.nvim_set_hl(0, "VertSplit", { fg = "#504945", bg = "#1d2021" })

			-- Link common highlight groups to Gruvbox equivalents
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#fb4934" })
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#fabd2f" })
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#83a598" })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "WinEnter",
		lazy = false, -- make sure we load this during startup
		priority = 999,
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "gruvbox",
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
					tabline = {
						lualine_a = {
							{
								"buffers",
								mode = 4,
							},
						},
						lualine_c = {},
						lualine_b = { "lsp_progress" },
						lualine_x = {},
						lualine_y = { "grapple" },
						lualine_z = { "tabs" },
					},
				},
			})
		end,
	},

	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},

	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Which character to use for drawing scope indicator
			symbol = "┃",
			draw = {
				animation = function()
					return 0
				end,
			},
		},
	},
}
