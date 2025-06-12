return {
	cmd = { "zls" },
	workspace_required = false,
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", "build.zig", ".git" },
	settings = {

		zls = {
			enable_inlay_hints = true,
			enable_snippets = true,
			warn_style = true,
		},
	},
}
