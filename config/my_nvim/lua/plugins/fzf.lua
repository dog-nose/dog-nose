return {
	-- fuzzy finder
	-- "junegunn/fzf",
	-- {
	-- 	"junegunn/fzf.vim",
	-- 	config = function()
	-- 		-- FZFのデフォルトオプションを設定
	-- 		vim.env.FZF_DEFAULT_OPTS = "--layout=reverse"
	-- 		-- FZFのデフォルトコマンドを設定
	-- 		vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --sort path --glob '!.git/**'"
	-- 		-- FZFのレイアウトを設定
	-- 		vim.g.fzf_layout = {
	-- 			up = "~90%",
	-- 			window = {
	-- 				width = 0.8,
	-- 				height = 0.8,
	-- 				yoffset = 0.5,
	-- 				xoffset = 0.5,
	-- 				border = "sharp",
	-- 			},
	-- 		}
	-- 		-- ランタイムパスにFZFのリポジトリを追加
	-- 		vim.cmd("set rtp+=$HOME/.local/share/nvim/lazy/fzf")
	-- 		-- FZFのカラースキームを設定
	-- 		vim.g.fzf_colors = {
	-- 			fg = { "fg", "Normal" },
	-- 			bg = { "bg", "Normal" },
	-- 			hl = { "fg", "Define" },
	-- 			["fg+"] = { "fg", "Type", "CursorColumn", "Normal" },
	-- 			["bg+"] = { "bg", "CursorLine", "CursorColumn" },
	-- 			["hl+"] = { "fg", "Define" },
	-- 			info = { "fg", "Identifier" },
	-- 			border = { "fg", "Define" },
	-- 			prompt = { "fg", "Identifier" },
	-- 			pointer = { "fg", "Type" },
	-- 			marker = { "fg", "Keyword" },
	-- 			spinner = { "fg", "Label" },
	-- 			header = { "fg", "Comment" },
	-- 		}

	-- 		vim.keymap.set("n", "<Leader>o", '<Cmd>call fzf#vim#files("", fzf#vim#with_preview(), 0)<CR>')
	-- 		vim.keymap.set("n", "<Leader>g", "<Cmd>GFiles?<CR>")
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<Leader>b",
	-- 			'<Cmd>call fzf#vim#buffers("", fzf#vim#with_preview({ "placeholder": "{1}" }), 0)<CR>'
	-- 		)
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<Leader>f",
	-- 			'fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(""), 1, fzf#vim#with_preview(), 0)<CR>'
	-- 		)
	-- 	end,
	-- },
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		keys = {
			-- { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Fzf: Find Files" },
			{ "<leader>o", "<cmd>FzfLua files<CR>", desc = "Fzf: Find Files" },
			-- { "<leader>fg", "<cmd>FzfLua git_files<CR>", desc = "Fzf: Git Files" },
			-- { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Fzf: Buffers" },
			{ "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "Fzf: Buffers" },
			-- { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Fzf: Recent Files" },
			-- { "<leader>fw", "<cmd>FzfLua live_grep<CR>", desc = "Fzf: Grep Words" },
		},
		config = function()
			require("fzf-lua").setup({
				files = {
					prompt = "❯",
					cwd_prompt = false,
					fd_icons = true,
					git_icons = true,
				},
				winopts = {
					height = 0.85,
					width = 0.95,
					preview = {
						layout = "horizontal", -- ← 左右分割
						horizontal = "right:50%", -- ← 右側50%を preview に
					},
				},
			})
		end,
	},
}
