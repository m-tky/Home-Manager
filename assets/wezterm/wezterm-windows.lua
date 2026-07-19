local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Start the Windows default WSL distribution in its Linux home directory.
-- Select the desired distribution with `wsl --set-default <distribution>`.
config.default_prog = { "wsl.exe", "--cd", "~" }
config.launch_menu = {
	{
		label = "WSL (default distribution)",
		args = { "wsl.exe", "--cd", "~" },
	},
	{
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
	},
}

-- Match the Kitty/Wayland WezTerm theme. The latter fonts are fallbacks for
-- Windows installations where Moralerspace has not been installed.
config.colors = {
	foreground = "#cdcecf",
	background = "#192330",
	cursor_bg = "#cdcecf",
	cursor_fg = "#192330",
	cursor_border = "#cdcecf",
	selection_bg = "#2b3b51",
	selection_fg = "#cdcecf",
	ansi = {
		"#393b44",
		"#c94f6d",
		"#81b29a",
		"#dbc074",
		"#719cd6",
		"#9d79d6",
		"#63cdcf",
		"#dfdfe0",
	},
	brights = {
		"#575860",
		"#d16983",
		"#8ebaa4",
		"#e0c989",
		"#86abdc",
		"#baa1e2",
		"#7ad5d6",
		"#e4e4e5",
	},
	tab_bar = {
		background = "#192330",
		active_tab = {
			bg_color = "#719cd6",
			fg_color = "#131a24",
		},
		inactive_tab = {
			bg_color = "#2b3b51",
			fg_color = "#738091",
		},
	},
}

config.font = wezterm.font_with_fallback({
	"Moralerspace Argon",
	"JetBrains Mono",
	"Consolas",
})
config.font_size = 10
config.window_background_opacity = 0.88
config.win32_system_backdrop = "Acrylic"
config.text_background_opacity = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.warn_about_missing_glyphs = false

-- Let WSL terminal applications use the Kitty graphics protocol.
config.enable_kitty_graphics = true

return config
