return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
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
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed }),
			})
		end,
	}, -- mason-lspconfig

	{
		"neovim/nvim-lspconfig",
		version = "*",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		event = { "BufReadPre", "BufNewFile" },
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

					-- LSP
					-- kmap('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>')
					-- kmap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
					-- kmap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
					-- kmap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
					-- kmap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
					-- kmap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
					-- kmap('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
					-- kmap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
					-- kmap('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
					-- kmap('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
					-- kmap('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
					-- kmap('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>')
					-- kmap('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
					-- kmap('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
					-- kmap('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
					-- kmap('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')
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
