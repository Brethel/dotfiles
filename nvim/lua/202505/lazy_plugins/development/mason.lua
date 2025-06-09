return {
	{
		"mason-org/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		lazy = false,
		config = function()
			-- import mason
			local mason = require("mason")

			-- import mason-lspconfig
			local mason_tool_installer = require("mason-tool-installer")

			-- enable mason and configure icons
			mason.setup({
				ui = {
					check_outdated_packages_on_open = true,
					border = "rounded", -- Use rounded borders for the Mason window
					icons = {
						package_installed = "✅",
						package_pending = "⏳",
						package_uninstalled = "❌",
					},
				},
				-- Custom list of registries (ensure default is included if still needed)
				registries = {
					"github:mason-org/mason-registry",
				},
				providers = {
					"mason.providers.registry-api",
					"mason.providers.client",
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint",
					"eslint_d",
				},
			})
		end,
	}, -- mason
}
