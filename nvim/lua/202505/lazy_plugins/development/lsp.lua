return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason-lspconfig").setup({
				-- list of servers for mason to install
				ensure_installed = {
					"ts_ls",
					"pyright",
					"gopls",
					"lua_ls",
					"html",
					"cssls",
					"tailwindcss",
					"emmet_ls",
				},
				-- auto-install configured servers (with lspconfig)
				automatic_installation = true, -- not the same as ensure_installed
			})
		end,
	}, -- mason-lspconfig

	{
		"neovim/nvim-lspconfig",
		version = "*",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		event = { "BufReadPre", "BufNewFile" },
		-- example using `opts` for defining servers
		-- opts = {
		-- 	servers = {
		-- 		lua_ls = {
		-- 			--- {{{ Lua
		-- 			settings = {
		-- 				Lua = {
		-- 					runtime = {
		-- 						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
		-- 						version = "LuaJIT",
		-- 						path = {
		-- 							"lua/?.lua",
		-- 							"lua/?/init.lua",
		-- 						},
		-- 					},
		-- 					codeLens = {
		-- 						enable = true,
		-- 					},
		-- 					diagnostics = {
		-- 						-- Get the language server to recognize the `vim` global
		-- 						globals = { "vim" },
		-- 					},
		-- 					completion = {
		-- 						callSnippet = "Replace",
		-- 					},
		-- 					workspace = {
		-- 						-- Make the server aware of Neovim runtime files
		-- 						library = {
		-- 							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
		-- 							[vim.fn.stdpath("config") .. "/lua"] = true,
		-- 						},
		-- 						checkThirdParty = false,
		-- 					},
		-- 					-- Do not send telemetry data containing a randomized but unique identifier
		-- 					telemetry = {
		-- 						enable = false,
		-- 					},
		-- 					hint = {
		-- 						enable = true,
		-- 						setType = false,
		-- 						paramType = true,
		-- 						paramName = "Disable",
		-- 						semicolon = "Disable",
		-- 						arrayIndex = "Disable",
		-- 					},
		-- 				},
		-- 			},
		-- 			--- }}}
		-- 		},
		-- 		gopls = {
		-- 			--- {{{ golang
		-- 			settings = {
		-- 				gopls = {
		-- 					analyses = {
		-- 						nilness = true,
		-- 						unusedparams = true,
		-- 						unusedwrite = true,
		-- 						useany = true,
		-- 					},
		-- 					experimentalPostfixCompletions = true,
		-- 					gofumpt = true,
		-- 					completeUnimported = true, -- This enables auto-import
		-- 					staticcheck = true,
		-- 					usePlaceholders = true,
		-- 					hints = {
		-- 						assignVariableTypes = true,
		-- 						compositeLiteralFields = true,
		-- 						compositeLiteralTypes = true,
		-- 						constantValues = true,
		-- 						functionTypeParameters = true,
		-- 						parameterNames = true,
		-- 						rangeVariableTypes = true,
		-- 					},
		-- 				},
		-- 			},
		-- 			--- }}}
		-- 		},
		-- 	},
		-- }, -- opts
		config = function(_, opts)
			-- local lspconfig = require("lspconfig")
			-- for server, config in pairs(opts.servers) do
			-- 	-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- 	-- `opts[server].capabilities, if you've defined it
			-- 	config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			-- 	config.root_markers = { ".git", "README.md" }
			--
			-- 	config = vim.tbl_extend("force", config, opts.servers[server])
			-- 	--	tprint(config)
			--
			-- 	lspconfig[server].setup(config)
			-- end

			vim.lsp.enable({
				"html",
				"lua",
				"gopls",
				"ocamllsp",
				"tl_ls",
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP Actions",
				callback = function(event)
					kmap(
						"n",
						"<leader>d",
						"<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
						{ desc = "LSP diagnostic" }
					)
					kmap(
						"n",
						"<leader>lr",
						"<cmd>lua vim.lsp.buf.rename()<CR>",
						{ buffer = event.buf, desc = "Rename" }
					)
					kmap(
						"n",
						"<leader>lca",
						"<cmd>lua vim.lsp.buf.code_action()<CR>",
						{ buffer = event.buf, desc = "Code Actions" }
					)
					kmap(
						"n",
						"<leader>lf",
						"<cmd>lua vim.lsp.buf.format()<CR>",
						{ buffer = event.buf, desc = "Format" }
					)
					kmap(
						"n",
						"K",
						"<cmd>lua vim.lsp.buf.hover()<CR>",
						{ buffer = event.buf, desc = "Hover Documentation" }
					)
				end,
			})

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})
		end,
	}, -- nvim-lspconfig
}
