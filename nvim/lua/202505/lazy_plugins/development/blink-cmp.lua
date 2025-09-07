return {
	{ "saghen/blink.compat", version = "*", lazy = true, opts = {} },
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"onsails/lspkind.nvim", -- pictograms
			"rafamadriz/friendly-snippets",
			-- { "supermaven-inc/supermaven-nvim", opts = { disable_inline_completion = true, -- disables inline completion for use with cmp disable_keymaps = true, -- disables built in keymaps for more manual control }, }, { "huijiro/blink-cmp-supermaven", },
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"echasnovski/mini.snippets",
		},
		event = { "InsertEnter", "CmdlineEnter" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "super-tab", -- "none",
				["<C-Tab>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = {
					function(cmp)
						return cmp.select_next()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						return cmp.select_prev()
					end,
					"snippet_backward",
					"fallback",
				},

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-up>"] = { "scroll_documentation_up", "fallback" },
				["<C-down>"] = { "scroll_documentation_down", "fallback" },
			}, -- keymap

			cmdline = {
				keymap = { preset = "enter" },
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				menu = {
					auto_show = true,
					-- draw = {
					-- 	treesitter = { "lsp" },
					-- 	columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
					-- },
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind" },
						},
						components = {
							kind_icon = {
								text = function(item)
									local kind = require("lspkind").symbol_map[item.kind] or ""
									return kind .. " "
								end,
								highlight = "CmpItemKind",
							},
							label = {
								text = function(item)
									return item.label
								end,
								highlight = "CmpItemAbbr",
							},
							kind = {
								text = function(item)
									return item.kind
								end,
								highlight = "CmpItemKind",
							},
						},
					}, -- draw
				}, -- menu
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
					},
				},
				accept = { auto_brackets = { enabled = true } },
				list = {
					selection = {

						preselect = function(ctx)
							return not require("blink.cmp").snippet_active({ direction = 1 })
						end,
						auto_insert = function(ctx)
							return vim.bo.filetype ~= "markdown"
						end,
					},
				},
			}, -- completion
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" }, -- supermaven
				providers = {
					-- supermaven = {
					-- 	name = "supermaven",
					-- 	module = "blink-cmp-supermaven",
					-- 	async = true,
					-- },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					lsp = {
						min_keyword_length = 2, -- Number of Chars to activate the provider
						score_offset = 0,
					},
					path = {
						min_keyword_length = 0,
					},
					snippets = {
						min_keyword_length = 2,
					},
					buffer = {
						min_keyword_length = 5,
						max_items = 5,
					},
				},
			},
			signature = { enabled = true },
			snippets = { preset = "luasnip" },
			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementa fgon instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for fg more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		}, -- opts
		opts_extend = { "sources.default" },
	}, -- blink-cmp
}
