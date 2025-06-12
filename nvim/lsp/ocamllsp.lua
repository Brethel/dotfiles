local util = require("lspconfig.util")

return {
	cmd = { "ocamllsp" },
	filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace")(fname))
	end,
}
