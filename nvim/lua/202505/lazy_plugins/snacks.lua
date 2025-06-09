return { -- lazy.nvim
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		scope = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		rename = { enabled = false },
		zen = { enabled = false },
		dashboard = {
			enabled = false,
		},
		bigfile = { enabled = true },
		explorer = { enabled = true },
		lazygit = {
			-- your lazygit configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			enabled = true,
			theme = {
				selectedLineBgColor = { bg = "CursorLine" },
			},
		},
		picker = {
			enabled = true,
			matcher = {
				frecency = true,
			},
			debug = { scores = false, leaks = false, explorer = false, files = false, proc = true },
		},
		notifier = {
			enabled = true,
			timeout = 1500,
			top_down = false, -- place notifications from top to bottom
			history = {
				minimal = false,
				title = " Notification History ",
				title_pos = "center",
				ft = "markdown",
				bo = { filetype = "snacks_notif_history", modifiable = false },
				wo = { winhighlight = "Normal:SnacksNotifierHistory" },
				keys = { q = "close" },
			},
		},
	}, -- opts
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				vim.g.dd = function(...)
					require("snacks").debug.inspect(...)
				end
				vim.g.bt = function()
					require("snacks").debug.backtrace()
				end
				vim.print = vim.g.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				require("snacks").toggle.diagnostics():map("<leader>ud")
				require("snacks").toggle.treesitter():map("<leader>uT")
				require("snacks").toggle.inlay_hints():map("<leader>uh")
			end, -- callback
		}) -- autocmd
	end, -- init
	keys = {
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history({})
			end,
			desc = "Notifications history",
		},
		{
			"<leader>g",
			function()
				require("snacks").lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>E",
			function()
				require("snacks").explorer()
			end,
			desc = "Explorer ( file tree )",
		},
		{
			"<C-t>",
			function()
				require("snacks").terminal()
			end,
			desc = "Toggle Terminal",
		},
		{
			"<leader>p",
			function()
				require("command-palette").show_commands()
			end,
			desc = "Command Palette",
		},
		-- find
		{
			"<leader><leader>",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fc",
			function()
				require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			function()
				require("snacks").picker.files({
					finder = "files",
					format = "file",
					show_empty = true,
					supports_live = true,
					-- In case you want to override the layout for this keymap
					-- layout = "vscode",
				})
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("snacks").picker.grep({
					-- search = "",
					-- we enable regex so the pattern is interpreted as a regex
					regex = true,
					-- no “live grep” needed here since we have a fixed pattern
					live = true,
					-- restrict search to the current working directory
					dirs = { vim.fn.getcwd() },
					-- include files ignored by .gitignore
					args = { "--no-ignore" },
					-- Start in normal mode
					on_show = function()
						vim.cmd.stopinsert()
					end,
					finder = "grep",
					format = "file",
					show_empty = true,
					supports_live = false,
					-- layout = "ivy",
				})
			end,
			desc = "Grep Files",
		},
		{
			"<leader>fp",
			function()
				require("snacks").picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				require("snacks").picker.recent()
			end,
			desc = "Recent",
		},

		-- LSP
		{
			"gd",
			function()
				require("snacks").picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				require("snacks").picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				require("snacks").picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				require("snacks").picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				require("snacks").picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<leader>ss",
			function()
				require("snacks").picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				require("snacks").picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},

		{
			"<leader>bd",
			function()
				require("snacks").bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>un",
			function()
				require("snacks").notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
	}, -- keymaps
} -- snacks
