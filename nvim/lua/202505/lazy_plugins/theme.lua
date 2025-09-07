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
			local mode_map = {
				["NORMAL"] = "NO",
				["O-PENDING"] = "N?",
				["INSERT"] = "IN",
				["VISUAL"] = "V ",
				["V-BLOCK"] = "VB",
				["V-LINE"] = "VL",
				["V-REPLACE"] = "VR",
				["REPLACE"] = "R ",
				["COMMAND"] = "! ",
				["SHELL"] = "SH",
				["TERMINAL"] = "T ",
				["EX"] = "X ",
				["S-BLOCK"] = "SB",
				["S-LINE"] = "SL",
				["SELECT"] = "S ",
				["CONFIRM"] = "Y?",
				["MORE"] = "M ",
			}
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "gruvbox",
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 500,
						tabline = 500,
						winbar = 500,
					},
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s)
								return mode_map[s] or s
							end,
						},
					},
					lualine_b = {
						{ "branch" },
						{ "filename", file_status = true, path = 1 },
					},
					lualine_c = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " " },
							diagnostics_color = {
								color_error = { fg = "#ff0000" },
								color_warn = { fg = "#ffff00" },
								color_info = { fg = "#00ffff" },
							},
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							diff_color = {
								added = { fg = "#00ff00" },
								modified = { fg = "#ffa500" },
								removed = { fg = "#cc0000" },
							},
						},
					},
					-- leave the defaults X,Y,Z...
					--		lualine_x = {},
					--		lualine_y = {},
					--		lualine_z = {},
				},
				tabline = {
					lualine_a = {
						{
							"buffers",
							mode = 4,
						},
					},
					lualine_b = { "lsp_progress" },
					lualine_c = {},
					--
					lualine_x = {},
					lualine_y = { "grapple" },
					lualine_z = { "tabs" },
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
			symbol = "", -- "┃",
			draw = {
				animation = function()
					return 0
				end,
			},
		},
	},
}
