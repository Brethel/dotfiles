local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}
local haswork,work = pcall(require,"work")

--- This helps with conflicting keys in pwsh
keys = {
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    { key = '\\', mods = 'ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
    { key = '\\', mods = 'CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
    { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
    { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
    { key = '@', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'P', mods = 'CTRL', action = act.ActivateCommandPalette },
    { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    { -- browser-like bindings for tabbing
	key = "t",
	mods = "CTRL",
	action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
    },
    {
	key = "w",
	mods = "CTRL",
	action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
    },
    {
	key = "Tab",
	mods = "CTRL",
	action = wezterm.action({ ActivateTabRelative = 1 }),
    },
    {
	key = "Tab",
	mods = "CTRL|SHIFT",
	action = wezterm.action({ ActivateTabRelative = -1 }),
    }, -- standard copy/paste bindings
    {
	key = "x",
	mods = "CTRL",
	action = "ActivateCopyMode",
    },
    {
	key = "v",
	mods = "CTRL|SHIFT",
	action = wezterm.action({ PasteFrom = "Clipboard" }),
    },
    {
	key = "c",
	mods = "CTRL|SHIFT",
	action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
    },
  {
	key = "v",
	mods = "SUPER",
	action = wezterm.action({ PasteFrom = "Clipboard" }),
    },
    {
	key = "c",
	mods = "SUPER",
	action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
    },

   -- This will create a new split and run the `top` program inside it
  {
    key = '-',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitVertical {
      -- args = { 'top' },
    },
  },
  -- This will create a new split and run the `top` program inside it
  {
    key = '\\',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitHorizontal {
     -- args = { 'top' },
    },
  },

}

-- Mousing bindings
mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
	event = { Up = { streak = 1, button = 'Left' } },
	mods = 'NONE',
	action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },

    -- and make CTRL-Click open hyperlinks
    {
	event = { Up = { streak = 1, button = 'Left' } },
	mods = 'CTRL',
	action = act.OpenLinkAtMouseCursor,
    },
    {
	event = { Down = { streak = 3, button = 'Left' } },
	action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
	mods = 'NONE',
    },
}

--- Default config settings
config.scrollback_lines = 7000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.hide_tab_bar_if_only_one_tab = true
-- config.color_scheme = 'Gruvbox Material'
config.color_scheme = 'Gruvbox Dark (Gogh)'
--- config.color_scheme = 'AdventureTime'
config.font = wezterm.font_with_fallback {
    {
	family ='ComicMono NF'
    },
    {
	family = 'FiraMono Nerd Font Mono'
    }

}
config.pane_focus_follows_mouse = true
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0
config.audible_bell = "Disabled"

config.inactive_pane_hsb = {
  saturation = 0.65,
  brightness = 0.5,
}
config.font_size = 15
config.line_height = 1.2

config.front_end = "OpenGL"
config.prefer_egl = true

-- if is_found(wezterm.target_triple, 'linux') then
-- 
-- end
--if is_found(wezterm.target_triple, 'apple') then
--
-- end
--config.max_fps = 60
config.max_fps = 120


config.launch_menu = launch_menu
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings

-- Allow overwriting for work stuff
if haswork then
    work.apply_to_config(config)
end

return config
