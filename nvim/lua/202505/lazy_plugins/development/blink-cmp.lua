return {
	{ "saghen/blink.compat", version = "*", lazy = true, opts = {} },
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
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
				preset = "none",
				["<C-Tab>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<S-CR>"] = { "accept", "fallback" },

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
			},
			snippets = { preset = "luasnip" },
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
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					window = { border = "rounded" },
				},
				accept = { auto_brackets = { enabled = true } },
			},
			list = {
				selection = function(ctx)
					return ctx.mode == "cmdline" and "auto_insert" or "preselect"
				end,
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
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
			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
			draw = {
				columns = {
					{ "kind_icon", "label", gap = 1 },
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
		},
		opts_extend = { "sources.default" },
	}, -- blink-cmp
}
