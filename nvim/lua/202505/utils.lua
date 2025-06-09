-- map kaybinding with default settings, plus any extra
function kmap(mode, lhs, rhs, opts)
	-- Default options
	local default_opts = {
		noremap = true,
		silent = true,
		-- Add other default options here
	}

	-- Merge custom options with defaults (custom options take priority)
	local merged_opts = vim.tbl_extend("force", default_opts, opts or {})

	-- Set the keymap
	vim.keymap.set(mode, lhs, rhs, merged_opts)
end

--
-- dump a table on console for debugging
function tprint(tbl, indent)
	if not indent then
		indent = 0
	end
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			tprint(v, indent + 1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end
