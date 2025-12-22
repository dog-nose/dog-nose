local wezterm = require("wezterm")
local keys = require("keys")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 15

-- 新しいタブをHOMEディレクトリで開く
config.default_cwd = wezterm.home_dir

-- 新しいタブボタンクリック時にHOMEディレクトリで開く
wezterm.on("new-tab-button-click", function(window, pane)
	window:perform_action(wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }), pane)
	return false -- デフォルトの動作を防ぐ
end)

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
-- タブの閉じるボタンを非表示
config.tab_max_width = 32
-- シンプルなタブバーを使用（閉じるボタンが表示されない）
config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーのカラー設定（Nordテーマに合わせる）
config.colors = {
	tab_bar = {
		-- アクティブなタブ（より明るい色: Nord3）
		active_tab = {
			bg_color = "#4c566a",
			fg_color = "#88c0d0", -- Nord8 (明るい青)
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		-- 非アクティブなタブ（後ろに下がるように濃い色: Nord0）
		inactive_tab = {
			bg_color = "#2e3440",
			fg_color = "#4c566a",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		-- ホバー時の非アクティブタブ
		inactive_tab_hover = {
			bg_color = "#434c5e",
			fg_color = "#d8dee9",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
	},
}

-- キーバインドの設定を読み込む
keys.setup(config)

return config
