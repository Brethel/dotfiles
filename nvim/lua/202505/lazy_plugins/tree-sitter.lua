return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		enabled = true,
		event = {
			"BufReadPost",
			"BufNewFile",
			"BufWritePre",
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	}, -- tree-sitter text objects

	{
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"windwp/nvim-ts-autotag",
				"ThePrimeagen/refactoring.nvim",
			},
			enabled = true,
			build = ":TSUpdate",
			event = { "BufReadPost", "BufNewFile" },
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"c_sharp",
					"cpp",
					"css",
					"dockerfile",
					"fsharp",
					"go",
					"gomod",
					"gdscript",
					"html",
					"javascript",
					"json",
					"jsx",
					"lua",
					"markdown",
					"markdown_inline",
					"ocaml",
					"regex",
					"sql",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				rainbow = { enable = true },
			}, -- opts

			config = function()
				require("nvim-treesitter.configs").setup({
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				})

				local parsers = {
					"bash",
					"c",
					"c_sharp",
					"cpp",
					"dockerfile",
					"fsharp",
					"go",
					"gdscript",
					"html",
					"javascript",
					"json",
					"jsx",
					"lua",
					"markdown",
					"markdown_inline",
					"ocaml",
					"regex",
					"sql",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
				}

				for _, parser in ipairs(parsers) do
					vim.api.nvim_create_autocmd("FileType", {
						pattern = parser,
						callback = function()
							if not require("nvim-treesitter.parsers").has_parser(parser) then
								require("nvim-treesitter.install").ensure_installed(parser)
							end
						end,
					})
				end

				require("nvim-treesitter.configs").setup({
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<CR>", -- set to `false` to disable one of the mappings
							node_incremental = false,
							scope_incremental = "<CR>",
							node_decremental = false,
						},
					},
				})
			end,
		},
		-- Refactor.nvim
		kmap({ "n", "x" }, "<leader>rr", function()
			require("refactoring").select_refactor()
		end, { desc = "[r]efacto[r]" }),
	}, -- tree-sitter
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("treesitter-context").setup()
		end,
	},
}
