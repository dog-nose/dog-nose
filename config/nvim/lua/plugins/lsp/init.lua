return {
	-- lazydev.nvim
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	-- vim.uv の型定義
	{ "Bilal2453/luvit-meta", lazy = true },
	-- 補完
	{
		"hrsh7th/nvim-cmp", --補完エンジン本体
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", --LSPを補完ソースに
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer", --bufferを補完ソースに
			"hrsh7th/cmp-path", --pathを補完ソースに
			"hrsh7th/vim-vsnip", --スニペットエンジン
			"hrsh7th/cmp-vsnip", --スニペットを補完ソースに
			"onsails/lspkind.nvim", --補完欄にアイコンを表示
		},
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			-- Lspkindのrequire
			local lspkind = require("lspkind")
			--補完関係の設定
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" }, --ソース類を設定
					{ name = "vsnip" }, -- For vsnip users.
					{ name = "buffer" },
					{ name = "path" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(), --Ctrl+pで補完欄を一つ上に移動
					["<C-n>"] = cmp.mapping.select_next_item(), --Ctrl+nで補完欄を一つ下に移動
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }), --Ctrl+yで補完を選択確定
				}),
				experimental = {
					ghost_text = false,
				},
				-- Lspkind(アイコン)を設定
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					}),
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" }, --ソース類を設定
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "path" }, --ソース類を設定
					{ name = "cmdline" },
				},
			})
		end,
	},
	-- lsp
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "folke/lazydev.nvim" },
		config = function()
			-- client, bufnrを引数に取るon_attach関数を定義
			local on_attach = function(client, bufnr)
				-- Disable LSP formatting in favor of conform.nvim
				client.server_capabilities.documentFormattingProvider = false
				local set = vim.keymap.set
				local opts = { buffer = bufnr, silent = true }

				-- LSP基本機能
				set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
				set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
				set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
				set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

				-- Diagnostics（エラー詳細表示）
				set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- カーソル位置のエラー詳細をフロートで表示
				set("n", "gx", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- 既存のgxも残す
				set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) -- 前のエラーへ移動
				set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- 次のエラーへ移動
				set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) -- 既存のg[も残す
				set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- 既存のg]も残す
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Diagnosticsの表示設定
			vim.diagnostic.config({
				virtual_text = false, -- 行末にエラーテキストを表示しない（鬱陶しいため）
				signs = {
					-- サイドバーにエラーサインを表示（新しいAPI）
					--  "", Warn = "", Hint = "󰌵", Info = "󰋽"
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰌵",
						[vim.diagnostic.severity.INFO] = "󰋽",
					},
				},
				underline = true, -- エラー箇所に下線を表示
				update_in_insert = false, -- 挿入モード中は更新しない
				severity_sort = true, -- 重要度順にソート
				float = {
					border = "rounded", -- フロートウィンドウの枠を角丸に
					source = "always", -- エラーのソース（LSPサーバー名など）を表示
					header = "",
					prefix = "",
				},
			})

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})

			-- shellcheck などの非LSPツールを自動インストール
			local mason_registry = require("mason-registry")
			local ensure_installed_tools = { "shellcheck" }
			for _, tool in ipairs(ensure_installed_tools) do
				local ok, package = pcall(mason_registry.get_package, tool)
				if ok and not package:is_installed() then
					package:install()
				end
			end

			local lspconfig = require("lspconfig")
			-- サーバーごとの設定
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							-- workspace と telemetry を無効にするかは任意（後述）
							-- workspace = {
							--   library = vim.api.nvim_get_runtime_file("", true),
							-- },
							-- telemetry = {
							--   enable = false,
							-- },
						},
					},
				},
				ts_ls = {},
				pyright = {},
			}

			-- 各 LSP サーバーを lspconfig で setup
			for server_name, config in pairs(servers) do
				config.on_attach = on_attach
				config.capabilities = capabilities
				lspconfig[server_name].setup(config)
			end
		end,
	},
}
