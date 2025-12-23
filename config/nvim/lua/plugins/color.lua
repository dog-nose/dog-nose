return {
	-- Nord カラースキーム（Weztermと統合）
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true, -- 背景透過を有効化
			terminal_colors = true, -- ターミナルカラーを定義
			diff = { mode = "bg" }, -- Diff表示モード
			styles = {
				comments = { italic = true },
				keywords = {},
				functions = {},
				variables = {},
			},
			-- すべてのUIコンポーネントを透過
			on_highlights = function(highlights, colors)
				highlights.StatusLine = { bg = "NONE" }
				highlights.StatusLineNC = { bg = "NONE" }
				highlights.LineNr = { bg = "NONE" }
				highlights.CursorLineNr = { bg = "NONE", fg = colors.nord12 } -- 絶対行番号をオレンジに
				highlights.SignColumn = { bg = "NONE" }
				highlights.FoldColumn = { bg = "NONE" }
				highlights.WinSeparator = { bg = "NONE" }
				highlights.TabLine = { bg = "NONE" }
				highlights.TabLineFill = { bg = "NONE" }
				highlights.EndOfBuffer = { bg = "NONE" }
			end,
		},
		config = function(_, opts)
			require("nord").setup(opts)
			vim.cmd.colorscheme("nord")
			-- 絶対行番号をオレンジ色に設定
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#D08770", bg = "NONE" })
			-- indent-blankline用のハイライトグループを定義
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4252", bg = "NONE" })
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#5E81AC", bg = "NONE" })
			vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#3B4252", bg = "NONE" })
		end,
	},
	-- { -- カラースキーマ
	-- 	"morhetz/gruvbox",
	-- 	config = function()
	-- 		-- vim.cmd("colorscheme gruvbox")
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		compile = false, -- コンパイルを有効にするとパフォーマンスが向上
	-- 		undercurl = true, -- スペルチェックなどのundercurlを有効化
	-- 		commentStyle = { italic = true },
	-- 		functionStyle = {},
	-- 		keywordStyle = { italic = true },
	-- 		statementStyle = { bold = true },
	-- 		typeStyle = {},
	-- 		transparent = true, -- 背景を透明にする場合はtrue
	-- 		dimInactive = false, -- 非アクティブウィンドウを暗くする
	-- 		terminalColors = true, -- ターミナルカラーを定義
	-- 		colors = {
	-- 			palette = {},
	-- 			theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	-- 		},
	-- 		overrides = function(colors) -- カスタムハイライトを追加
	-- 			return {}
	-- 		end,
	-- 		theme = "wave", -- デフォルトテーマ: "wave", "lotus", "dragon"
	-- 		background = {
	-- 			dark = "wave", -- ダークモード時のテーマ
	-- 			light = "lotus", -- ライトモード時のテーマ
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("kanagawa").setup(opts)
	-- 		-- デフォルトでは適用しない（試したい場合は以下をアンコメント）
	-- 		-- vim.cmd("colorscheme kanagawa")
	-- 		-- vim.cmd("colorscheme kanagawa-wave")
	-- 		vim.cmd("colorscheme kanagawa-dragon")
	-- 		-- vim.cmd("colorscheme kanagawa-lotus")
	-- 	end,
	-- },
}
