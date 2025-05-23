return {
	-- ステータスライン
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{
							"filename",
							file_status = true, -- Displays file status (readonly status, modified status)
							newfile_status = false, -- Display new file status (new file means no write after created)
							path = 0, -- 0: Just the filename
							-- 1: Relative path
							-- 2: Absolute path
							-- 3: Absolute path, with tilde as the home directory
							-- 4: Filename and parent dir, with tilde as the home directory
							shorting_target = 40, -- Shortens path to leave 40 spaces in the window
							-- for other components. (terrible name, any suggestions?)
							symbols = {
								modified = " ", -- Text to show when the file is modified.
								readonly = " ", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "[New]", -- Text to show for newly created file before first write
							},
						},
					},
					lualine_c = {
						"branch",
						"diff",
						{
							"diagnostics",
							symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				-- inactive_sections = {
				--   lualine_a = {},
				--   lualine_b = {},
				--   lualine_c = {'filename'},
				--   lualine_x = {'location'},
				--   lualine_y = {},
				--   lualine_z = {}
				-- },
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	-- コマンド
	"MunifTanjim/nui.nvim",
	{
		"folke/noice.nvim",
		config = function()
			local status, noice = pcall(require, "noice")
			if not status then
				return
			end

			noice.setup({
				-- lsp = {
				--   -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				--   override = {
				--     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				--     ["vim.lsp.util.stylize_markdown"] = true,
				--     ["cmp.entry.get_documentation"] = true,
				--   },
				-- },
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = false, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				views = {
					cmdline_popup = {
						position = {
							row = "20%", -- 上下位置: 90% は画面下寄り（50%が中央）
							-- col = "50%", -- 左右位置: 中央
						},
						-- size = {
						-- 	width = 60,
						-- 	height = "auto",
						-- },
					},
				},
				cmdline = {
					view = "cmdline_popup", -- これを使うことで上記設定を反映
				},
			})
		end,
	},
	-- indent
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup({
				indent = {
					char = "│", -- インデントの線の文字
					tab_char = "│", -- タブに対しても線を表示
				},
				whitespace = {
					remove_blankline_trail = false,
				},
				scope = {
					enabled = false,
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		opts = {
			symbol = "▏",
			options = { try_as_border = true },
			delay = 10,
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"Trouble",
					"alpha",
					"dashboard",
					"fzf",
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"notify",
					"snacks_dashboard",
					"snacks_notif",
					"snacks_terminal",
					"snacks_win",
					"toggleterm",
					"trouble",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		config = function()
			require("neoscroll").setup({
				-- アニメーション時間の設定（ms）
				hide_cursor = true, -- スクロール中にカーソルを非表示
				stop_eof = true, -- EOF で止める
				respect_scrolloff = true, -- scrolloff の設定を尊重
				cursor_scrolls_alone = true, -- カーソルが画面の外にあるときだけスクロール
				easing_function = "sine", -- "quadratic", "cubic", "sine", etc.
				performance_mode = false, -- パフォーマンス重視モード
			})

			require("neoscroll.config").set_mappings({
				-- 以下のキーに対してアニメーション付きスクロールを有効化
				["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } },
				["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } },
				-- ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200" } },
				-- ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200" } },
				-- ["<C-y>"] = { "scroll", { "-0.10", "false", "100" } },
				-- ["<C-e>"] = { "scroll", { "0.10", "false", "100" } },
				["zt"] = { "zt", { "150" } },
				["zz"] = { "zz", { "150" } },
				["zb"] = { "zb", { "150" } },
			})
		end,
	},
}
