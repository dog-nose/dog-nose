local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 15

-- カラースキームの設定
-- config.color_scheme = "AdventureTime"
config.color_scheme = "nord"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0

-- タイトルバーの非表示
config.window_decorations = "RESIZE"
-- タブバーの設定
config.show_tabs_in_tab_bar = true
-- タブが1つだけのときにタブバーを非表示にしない
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

return config
