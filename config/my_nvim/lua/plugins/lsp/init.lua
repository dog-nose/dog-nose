return {
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
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			-- client, bufnrを引数に取るon_attach関数を定義
			local on_attach = function(client, _)
				-- Disable LSP formatting in favor of conform.nvim
				client.server_capabilities.documentFormattingProvider = false
				local set = vim.keymap.set
				set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
				set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
				set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
				set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
				set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
				set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
				set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
				set("n", "gx", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
				set("n", "g[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
				set("n", "g]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
				set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					local settings = {}
					if server_name == "lua_ls" then
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								-- -- 以下の2つがなぜ必要なのかわからない
								-- -- 設定するとハイライトが有効になるまで時間がかかったので止めた
								-- workspace = {
								--   library = vim.api.nvim_get_runtime_file("", true)
								-- },
								-- telemetry = {
								--   enable = false
								-- }
							},
						}
					end
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities, --cmpを連携⇐ココ！
						settings = settings,
					})
				end,
			})
		end,
	},
}
