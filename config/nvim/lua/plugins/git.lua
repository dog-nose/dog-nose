return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				-- サインカラムに表示するアイコン
				signs = {
					-- add = { text = "" },
					add = { text = "▎" },
					-- change = { text = "" },
					change = { text = "▎" },
					-- delete = { text = "" },
					delete = { text = "▎" },
					topdelete = { text = "▎" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				-- ステージング済みの変更用アイコン
				signs_staged = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = " " },
					topdelete = { text = " " },
					changedelete = { text = "▎" },
				},
				-- ステージング済み変更を表示
				signs_staged_enable = true,
				-- サインカラムに表示
				signcolumn = true,
				-- 行番号にハイライトを適用しない（diagnosticsと競合するため）
				numhl = false,
				-- 行全体にハイライトを適用しない
				linehl = false,
				-- 単語単位のdiffハイライト
				word_diff = false,
				-- 現在の行にブレームを表示（<Leader>gbで切り替え可能）
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 行末に表示
					delay = 500, -- 500ms後に表示
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "   <author>, <author_time:%Y-%m-%d> - <summary>",
				-- プレビューウィンドウの設定
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				-- キーマップ
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- ナビゲーション: 次/前の変更箇所へ移動
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next git hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous git hunk" })

					-- アクション: ステージング、リセット、プレビューなど
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage selected hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset selected hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle git blame" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Diff this ~" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

					-- テキストオブジェクト: ihでhunkを選択
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
				end,
			})
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>l", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
