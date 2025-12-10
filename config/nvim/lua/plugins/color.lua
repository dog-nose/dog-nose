return {
	{ -- カラースキーマ
		"morhetz/gruvbox",
		config = function()
			-- vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			compile = false, -- コンパイルを有効にするとパフォーマンスが向上
			undercurl = true, -- スペルチェックなどのundercurlを有効化
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- 背景を透明にする場合はtrue
			dimInactive = false, -- 非アクティブウィンドウを暗くする
			terminalColors = true, -- ターミナルカラーを定義
			colors = {
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors) -- カスタムハイライトを追加
				return {}
			end,
			theme = "wave", -- デフォルトテーマ: "wave", "lotus", "dragon"
			background = {
				dark = "wave", -- ダークモード時のテーマ
				light = "lotus", -- ライトモード時のテーマ
			},
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
			-- デフォルトでは適用しない（試したい場合は以下をアンコメント）
			-- vim.cmd("colorscheme kanagawa")
			-- vim.cmd("colorscheme kanagawa-wave")
			vim.cmd("colorscheme kanagawa-dragon")
			-- vim.cmd("colorscheme kanagawa-lotus")
		end,
	},
}
