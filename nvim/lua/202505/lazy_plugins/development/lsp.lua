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
					-- "pyright",
					"gopls",
					"lua_ls",
					"html",
					"cssls",
					"tailwindcss",
					-- "emmet_ls",
					"csharp_ls",
					"fsautocomplete",
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
				"cssls",
				"tailwindcss",
				"lua_ls",
				"gopls",
				"ocamllsp",
				"tl_ls",
				"zls",
				"csharp_ls",
				"fsautocomplete",
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
				virtual_text = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "ErrorMsg",
						[vim.diagnostic.severity.WARN] = "WarningMsg",
					},
				},
			})
			local function restart_lsp(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })

				for _, client in ipairs(clients) do
					vim.lsp.stop_client(client.id)
				end

				vim.defer_fn(function()
					vim.cmd("edit")
				end, 100)
			end

			vim.api.nvim_create_user_command("LspRestart", function()
				restart_lsp()
			end, {})

			local function lsp_status()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })

				if #clients == 0 then
					print("󰅚 No LSP clients attached")
					return
				end

				print("󰒋 LSP Status for buffer " .. bufnr .. ":")
				print(
					"─────────────────────────────────"
				)

				for i, client in ipairs(clients) do
					print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
					print("  Root: " .. (client.config.root_dir or "N/A"))
					print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

					-- Check capabilities
					local caps = client.server_capabilities
					local features = {}
					if caps.completionProvider then
						table.insert(features, "completion")
					end
					if caps.hoverProvider then
						table.insert(features, "hover")
					end
					if caps.definitionProvider then
						table.insert(features, "definition")
					end
					if caps.referencesProvider then
						table.insert(features, "references")
					end
					if caps.renameProvider then
						table.insert(features, "rename")
					end
					if caps.codeActionProvider then
						table.insert(features, "code_action")
					end
					if caps.documentFormattingProvider then
						table.insert(features, "formatting")
					end

					print("  Features: " .. table.concat(features, ", "))
					print("")
				end
			end

			vim.api.nvim_create_user_command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })

			local function check_lsp_capabilities()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })

				if #clients == 0 then
					print("No LSP clients attached")
					return
				end

				for _, client in ipairs(clients) do
					print("Capabilities for " .. client.name .. ":")
					local caps = client.server_capabilities

					local capability_list = {
						{ "Completion", caps.completionProvider },
						{ "Hover", caps.hoverProvider },
						{ "Signature Help", caps.signatureHelpProvider },
						{ "Go to Definition", caps.definitionProvider },
						{ "Go to Declaration", caps.declarationProvider },
						{ "Go to Implementation", caps.implementationProvider },
						{ "Go to Type Definition", caps.typeDefinitionProvider },
						{ "Find References", caps.referencesProvider },
						{ "Document Highlight", caps.documentHighlightProvider },
						{ "Document Symbol", caps.documentSymbolProvider },
						{ "Workspace Symbol", caps.workspaceSymbolProvider },
						{ "Code Action", caps.codeActionProvider },
						{ "Code Lens", caps.codeLensProvider },
						{ "Document Formatting", caps.documentFormattingProvider },
						{ "Document Range Formatting", caps.documentRangeFormattingProvider },
						{ "Rename", caps.renameProvider },
						{ "Folding Range", caps.foldingRangeProvider },
						{ "Selection Range", caps.selectionRangeProvider },
					}

					for _, cap in ipairs(capability_list) do
						local status = cap[2] and "✓" or "✗"
						print(string.format("  %s %s", status, cap[1]))
					end
					print("")
				end
			end

			vim.api.nvim_create_user_command(
				"LspCapabilities",
				check_lsp_capabilities,
				{ desc = "Show LSP capabilities" }
			)

			local function lsp_diagnostics_info()
				local bufnr = vim.api.nvim_get_current_buf()
				local diagnostics = vim.diagnostic.get(bufnr)

				local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

				for _, diagnostic in ipairs(diagnostics) do
					local severity = vim.diagnostic.severity[diagnostic.severity]
					counts[severity] = counts[severity] + 1
				end

				print("󰒡 Diagnostics for current buffer:")
				print("  Errors: " .. counts.ERROR)
				print("  Warnings: " .. counts.WARN)
				print("  Info: " .. counts.INFO)
				print("  Hints: " .. counts.HINT)
				print("  Total: " .. #diagnostics)
			end

			vim.api.nvim_create_user_command(
				"LspDiagnostics",
				lsp_diagnostics_info,
				{ desc = "Show LSP diagnostics count" }
			)

			local function lsp_info()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })

				print(
					"═══════════════════════════════════"
				)
				print("           LSP INFORMATION          ")
				print(
					"═══════════════════════════════════"
				)
				print("")

				-- Basic info
				print("󰈙 Language client log: " .. vim.lsp.get_log_path())
				print("󰈔 Detected filetype: " .. vim.bo.filetype)
				print("󰈮 Buffer: " .. bufnr)
				print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
				print("")

				if #clients == 0 then
					print("󰅚 No LSP clients attached to buffer " .. bufnr)
					print("")
					print("Possible reasons:")
					print("  • No language server installed for " .. vim.bo.filetype)
					print("  • Language server not configured")
					print("  • Not in a project root directory")
					print("  • File type not recognized")
					return
				end

				print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
				print(
					"─────────────────────────────────"
				)

				for i, client in ipairs(clients) do
					print(string.format("󰌘 Client %d: %s", i, client.name))
					print("  ID: " .. client.id)
					print("  Root dir: " .. (client.config.root_dir or "Not set"))
					print("  Command: " .. table.concat(client.config.cmd or {}, " "))
					print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

					-- Server status
					if client.is_stopped() then
						print("  Status: 󰅚 Stopped")
					else
						print("  Status: 󰄬 Running")
					end

					-- Workspace folders
					if client.workspace_folders and #client.workspace_folders > 0 then
						print("  Workspace folders:")
						for _, folder in ipairs(client.workspace_folders) do
							print("    • " .. folder.name)
						end
					end

					-- Attached buffers count
					local attached_buffers = {}
					for buf, _ in pairs(client.attached_buffers or {}) do
						table.insert(attached_buffers, buf)
					end
					print("  Attached buffers: " .. #attached_buffers)

					-- Key capabilities
					local caps = client.server_capabilities
					local key_features = {}
					if caps.completionProvider then
						table.insert(key_features, "completion")
					end
					if caps.hoverProvider then
						table.insert(key_features, "hover")
					end
					if caps.definitionProvider then
						table.insert(key_features, "definition")
					end
					if caps.documentFormattingProvider then
						table.insert(key_features, "formatting")
					end
					if caps.codeActionProvider then
						table.insert(key_features, "code_action")
					end

					if #key_features > 0 then
						print("  Key features: " .. table.concat(key_features, ", "))
					end

					print("")
				end

				-- Diagnostics summary
				local diagnostics = vim.diagnostic.get(bufnr)
				if #diagnostics > 0 then
					print("󰒡 Diagnostics Summary:")
					local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

					for _, diagnostic in ipairs(diagnostics) do
						local severity = vim.diagnostic.severity[diagnostic.severity]
						counts[severity] = counts[severity] + 1
					end

					print("  󰅚 Errors: " .. counts.ERROR)
					print("  󰀪 Warnings: " .. counts.WARN)
					print("  󰋽 Info: " .. counts.INFO)
					print("  󰌶 Hints: " .. counts.HINT)
					print("  Total: " .. #diagnostics)
				else
					print("󰄬 No diagnostics")
				end

				print("")
				print("Use :LspLog to view detailed logs")
				print("Use :LspCapabilities for full capability list")
			end

			-- Create command
			vim.api.nvim_create_user_command("LspInfo", lsp_info, { desc = "Show comprehensive LSP information" })
		end,
	}, -- nvim-lspconfig
}
