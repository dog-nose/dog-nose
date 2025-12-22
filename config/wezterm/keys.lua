local wezterm = require("wezterm")

local M = {}

function M.setup(config)
	config.keys = {
		-- Cmd+T で新しいタブをHOMEディレクトリで開く
		{
			key = "t",
			mods = "CMD",
			action = wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		},

		-- ペイン分割
		-- Cmd+Shift+h: 横分割（Horizontal Split - 下側に新しいペイン）
		{
			key = "h",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		-- Cmd+Shift+v: 縦分割（Vertical Split - 右側に新しいペイン）
		{
			key = "v",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},

		-- ペイン移動（Vim風）
		{
			key = "h",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},

		-- コピーモード（Vimライク）
		{
			key = "[",
			mods = "CMD",
			action = wezterm.action.ActivateCopyMode,
		},

		-- ペイン操作
		-- Cmd+w: ペインを閉じる
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		-- Cmd+z: ペインのズーム切り替え
		{
			key = "z",
			mods = "CMD",
			action = wezterm.action.TogglePaneZoomState,
		},
	}
end

return M
