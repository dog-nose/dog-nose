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
						statusline = { "NvimTree" },
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
		opts = {
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
				},
				buftypes = { "terminal" },
			},
		},
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
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "*",
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
				mappings = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
				-- アニメーション時間の設定（ms）
				hide_cursor = true, -- スクロール中にカーソルを非表示
				stop_eof = true, -- EOF で止める
				respect_scrolloff = true, -- scrolloff の設定を尊重
				cursor_scrolls_alone = true, -- カーソルが画面の外にあるときだけスクロール
				easing_function = "sine", -- "quadratic", "cubic", "sine", etc.
				performance_mode = false, -- パフォーマンス重視モード
			})
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			local logo = [[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"

			-- 起動時間を記録
			local start_time = vim.fn.reltime()

			-- 既存のショートカットキーを取得
			local reserved_keys = { "n", "f", "r", "g", "c", "l", "q" }

			-- 既存キーを除外したアルファベットリストを生成
			local function get_available_keys()
				local available = {}
				local reserved_set = {}
				for _, key in ipairs(reserved_keys) do
					reserved_set[key] = true
				end

				for i = string.byte("a"), string.byte("z") do
					local char = string.char(i)
					if not reserved_set[char] then
						table.insert(available, char)
					end
				end
				return available
			end

			-- 最近のプロジェクトを取得する関数
			local function get_recent_projects()
				local projects = {}
				local project_dirs = {}

				-- 最近のファイルからプロジェクトディレクトリを推測
				local oldfiles = vim.v.oldfiles or {}
				for _, file in ipairs(oldfiles) do
					if vim.fn.filereadable(file) == 1 then
						-- gitリポジトリのルートを探す
						local dir = vim.fn.fnamemodify(file, ":h")
						local git_dir = vim.fn.finddir(".git", dir .. ";")
						if git_dir ~= "" then
							local project_root = vim.fn.fnamemodify(git_dir, ":h")
							if not project_dirs[project_root] then
								project_dirs[project_root] = true
								table.insert(projects, {
									name = vim.fn.fnamemodify(project_root, ":t"),
									path = project_root,
								})
								if #projects >= 5 then
									break
								end
							end
						end
					end
				end
				return projects
			end

			-- nvim-web-deviconsからアイコンを取得
			local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

			-- アイコンを取得するヘルパー関数
			local function get_icon_with_fallback(filename, extension, fallback_icon)
				if devicons_ok then
					local icon, hl = devicons.get_icon(filename, extension, { default = true })
					return icon or fallback_icon, hl or "Title"
				end
				return fallback_icon, "Title"
			end

			-- 各メニューアイテムのアイコンを取得
			local new_file_icon, new_file_hl = get_icon_with_fallback("new.txt", "txt", " ")
			local find_file_icon, find_file_hl = get_icon_with_fallback("search", "lua", " ")
			local recent_files_icon, recent_files_hl = get_icon_with_fallback("history.log", "log", " ")
			local find_text_icon, find_text_hl = get_icon_with_fallback("grep", "sh", " ")
			local config_icon, config_hl = get_icon_with_fallback("init.lua", "lua", " ")
			local lazy_icon, lazy_hl = get_icon_with_fallback("package.json", "json", " ")
			local quit_icon, quit_hl = get_icon_with_fallback("exit", "sh", " ")

			local center_items = {
				{
					icon = new_file_icon .. " ",
					icon_hl = new_file_hl,
					desc = "New File",
					desc_hl = "String",
					key = "n",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = "enew",
				},
				{
					icon = find_file_icon .. " ",
					icon_hl = find_file_hl,
					desc = "Find File",
					desc_hl = "String",
					key = "f",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = function()
						require("fzf-lua").files()
					end,
				},
				{
					icon = recent_files_icon .. " ",
					icon_hl = recent_files_hl,
					desc = "Recent Files",
					desc_hl = "String",
					key = "r",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = function()
						require("fzf-lua").oldfiles()
					end,
				},
				{
					icon = find_text_icon .. " ",
					icon_hl = find_text_hl,
					desc = "Find Text",
					desc_hl = "String",
					key = "g",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = function()
						require("fzf-lua").live_grep()
					end,
				},
				{
					icon = config_icon .. " ",
					icon_hl = config_hl,
					desc = "Config",
					desc_hl = "String",
					key = "c",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = "edit ~/.config/nvim/init.lua",
				},
				{
					icon = lazy_icon .. " ",
					icon_hl = lazy_hl,
					desc = "Lazy",
					desc_hl = "String",
					key = "l",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = "Lazy",
				},
				{
					icon = quit_icon .. " ",
					icon_hl = quit_hl,
					desc = "Quit",
					desc_hl = "String",
					key = "q",
					keymap = "",
					key_hl = "Number",
					key_format = " %s",
					action = "quit",
				},
			}

			require("dashboard").setup({
				theme = "doom",
				config = {
					header = vim.split(logo, "\n"),
					center = center_items,
					footer = function()
						local footer = {}

						-- プロジェクト一覧を表示
						local projects = get_recent_projects()
						if #projects > 0 then
							local available_keys = get_available_keys()
							-- nvim-web-deviconsを取得
							local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

							table.insert(footer, "")
							table.insert(footer, " Recent Projects (press key to open):")
							for i, project in ipairs(projects) do
								local key = available_keys[i] or tostring(i)

								-- プロジェクトのアイコンを取得
								local icon = " "  -- デフォルトのフォルダアイコン
								if devicons_ok then
									-- ディレクトリ名からアイコンを取得（拡張子として扱う）
									local dir_icon = devicons.get_icon(project.name, "", { default = true })
									if dir_icon then
										icon = dir_icon
									end
								end

								-- プロジェクト名を左、キーを右に表示（最大幅を60文字と仮定）
								local max_width = 60
								local name = icon .. " " .. project.name
								local key_str = string.format("[%s]", key)
								local spaces = string.rep(" ", math.max(1, max_width - vim.fn.strwidth(name) - vim.fn.strwidth(key_str)))
								table.insert(footer, string.format("   %s%s%s", name, spaces, key_str))
							end
							end

						-- プラグイン情報を取得
						local lazy_ok, lazy = pcall(require, "lazy")
						local total_plugins = 0
						local loaded_plugins = 0

						if lazy_ok then
							local stats = lazy.stats()
							total_plugins = stats.count
							loaded_plugins = stats.loaded
						end

						-- 起動時間を計算して表示
						local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000
						table.insert(footer, "")
						table.insert(
							footer,
							string.format(
								"⚡ Neovim loaded %d/%d plugins in %.2f ms",
								loaded_plugins,
								total_plugins,
								elapsed
							)
						)

						return footer
					end,
				},
			})

			-- dashboardでインデント線を無効化 & プロジェクトのキーマップを設定
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dashboard",
				callback = function()
					-- インデント線を無効化
					vim.opt_local.list = false
					vim.b.miniindentscope_disable = true
					local ibl_ok = pcall(require, "ibl")
					if ibl_ok then
						require("ibl").setup_buffer(0, { enabled = false })
					end

					-- プロジェクトのキーマップを設定
					local projects = get_recent_projects()
					local available_keys = get_available_keys()
					for i, project in ipairs(projects) do
						local key = available_keys[i] or tostring(i)
						vim.keymap.set("n", key, function()
							vim.cmd("cd " .. vim.fn.fnameescape(project.path))
							require("fzf-lua").files()
						end, { buffer = true, silent = true, desc = "Open " .. project.name })
					end
				end,
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
