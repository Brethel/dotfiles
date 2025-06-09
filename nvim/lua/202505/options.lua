local _GG = vim.g -- Global variable
local _OPT = vim.opt -- Set options (global/buffer/windows-scoped)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
_GG.mapleader = " "
_GG.maplocalleader = " "

-----------------------------------------------------------
-- General
-----------------------------------------------------------
_OPT.mouse = "a" -- Enable mouse support
_OPT.clipboard = "unnamedplus" -- Copy/paste to system clipboard
_OPT.swapfile = false -- Don't use swapfile
_OPT.completeopt = { "menu,menuone,noinsert,noselect,popup,fuzzy" } -- Autocomplete options
_OPT.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"context:12",
	"algorithm:histogram",
	"linematch:200",
	"indent-heuristic",
}

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
_OPT.number = true -- Show line number
_OPT.relativenumber = true -- relative line number
_OPT.showmatch = true -- Highlight matching parenthesis
_OPT.foldmethod = "marker" -- Enable folding (default 'foldmarker')
_OPT.colorcolumn = "80,120" -- Line lenght marker at 80 and 120 columns
_OPT.splitright = true -- Vertical split to the right
_OPT.splitbelow = true -- Horizontal split to the bottom
_OPT.ignorecase = true -- Ignore case letters when search
_OPT.smartcase = true -- Ignore lowercase for the whole pattern
_OPT.linebreak = true -- Wrap on word boundary
_OPT.termguicolors = true -- Enable 24-bit RGB colors
_OPT.laststatus = 3 -- Set global statusline
_OPT.cmdheight = 1 -- 1 line for cmd
-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
_OPT.expandtab = true -- Use spaces instead of tabs
_OPT.shiftwidth = 4 -- Shift 4 spaces when tab
_OPT.tabstop = 4 -- 1 tab == 4 spaces
_OPT.smartindent = true -- Autoindent new lines

-- incremental search
_OPT.incsearch = true

-- backspace
_OPT.backspace = "indent,eol,start"

-- split windows
_OPT.splitbelow = true
_OPT.splitright = true

_OPT.backup = false
_OPT.conceallevel = 2
_OPT.cursorline = true
_OPT.expandtab = true
-- _OPT.foldmethod = "expr"
-- _OPT.foldexpr = "nvim_treesitter#foldexpr()"
_OPT.hidden = true
_OPT.ignorecase = true
_OPT.inccommand = "split"
_OPT.joinspaces = false
_OPT.list = true
_OPT.number = true
_OPT.relativenumber = true
_OPT.scrolloff = 999 -- "center" the cursor vertically
_OPT.shortmess:append("c")
_OPT.showmode = true
_OPT.sidescrolloff = 8
_OPT.signcolumn = "yes:2"
_OPT.smartcase = true
_OPT.smartindent = true
_OPT.splitbelow = true
_OPT.splitright = true
_OPT.undofile = true
_OPT.updatetime = 250
_OPT.wrap = true
_OPT.pumheight = 12 -- Limit completion menu height
_OPT.updatetime = 150 -- Faster completion feedback

-- Basic editor setup with Gruvbox-friendly settings
_OPT.background = "dark"
_OPT.termguicolors = true
_OPT.list = false
_OPT.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
_OPT.hidden = true -- Enable background buffers
_OPT.history = 100 -- Remember N lines in history
_OPT.lazyredraw = true -- Faster scrolling
_OPT.synmaxcol = 240 -- Max column for syntax highlight
_OPT.updatetime = 250 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
_OPT.shortmess:append("sI")

if _GG.neovide then
	_OPT.guifont = "FiraCode Nerd Font Mono,Symbols Nerd Font Mono:h12"
	_GG.neovide_normal_opacity = 0.9
	_GG.neovide_scale_factor = 1.1
	_GG.neovide_cursor_animation_length = 0
end

-- Disable builtin plugins
local disabled_built_ins = {
	"2html_plugin",
	"bugreport",
	"compiler",
	"ftplugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"netrw",
	"netrwFileHandlers",
	"netrwPlugin",
	"netrwSettings",
	"optwin",
	"rplugin",
	"rrhelper",
	"spellfile_plugin",
	"synmenu",
	-- "syntax",
	"tar",
	"tarPlugin",
	-- "tohtml",
	"tutor",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	_GG["loaded_" .. plugin] = 1
end

-- change letters for emojis on signcolumn
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "× ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "💡 ",
			[vim.diagnostic.severity.HINT] = "¡ ",
		},
		-- texthl = {
		-- 	[vim.diagnostic.severity.ERROR] = "Error",
		-- 	[vim.diagnostic.severity.WARN] = "Warn",
		-- 	[vim.diagnostic.severity.INFO] = "Info",
		-- 	[vim.diagnostic.severity.HINT] = "Hint",
		-- },
		-- numhl = {
		-- 	[vim.diagnostic.severity.ERROR] = "",
		-- 	[vim.diagnostic.severity.WARN] = "",
		-- 	[vim.diagnostic.severity.INFO] = "",
		-- 	[vim.diagnostic.severity.HINT] = "",
		-- },
	},
	underline = true, -- Specify Underline diagnostics
	update_in_insert = false, -- Keep diagnostics active in insert mode
	virtual_text = {
		spacing = 40,
		source = "if_many",
		prefix = "●",
		format = function(diagnostic)
			-- Replace newline and tab characters with space for more compact diagnostics
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
	-- virtual_lines = true,
	severity_sort = true,
})
