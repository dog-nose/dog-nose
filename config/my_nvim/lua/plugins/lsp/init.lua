if true then
	return {}
end
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
	-- -- lspconfig
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	-- event = "LazyFile",
	-- 	dependencies = {
	-- 		"mason.nvim",
	-- 		{ "mason-org/mason-lspconfig.nvim", config = function() end },
	-- 	},
	-- 	opts = function()
	-- 		---@class PluginLspOpts
	-- 		local ret = {
	-- 			-- options for vim.diagnostic.config()
	-- 			---@type vim.diagnostic.Opts
	-- 			diagnostics = {
	-- 				underline = true,
	-- 				update_in_insert = false,
	-- 				virtual_text = {
	-- 					spacing = 4,
	-- 					source = "if_many",
	-- 					prefix = "●",
	-- 					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
	-- 					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
	-- 					-- prefix = "icons",
	-- 				},
	-- 				severity_sort = true,
	-- 				signs = {
	-- 					text = {
	-- 						[vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
	-- 						[vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
	-- 						[vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
	-- 						[vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
	-- 					},
	-- 				},
	-- 			},
	-- 			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
	-- 			-- Be aware that you also will need to properly configure your LSP server to
	-- 			-- provide the inlay hints.
	-- 			inlay_hints = {
	-- 				enabled = true,
	-- 				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
	-- 			},
	-- 			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
	-- 			-- Be aware that you also will need to properly configure your LSP server to
	-- 			-- provide the code lenses.
	-- 			codelens = {
	-- 				enabled = false,
	-- 			},
	-- 			-- add any global capabilities here
	-- 			capabilities = {
	-- 				workspace = {
	-- 					fileOperations = {
	-- 						didRename = true,
	-- 						willRename = true,
	-- 					},
	-- 				},
	-- 			},
	-- 			-- options for vim.lsp.buf.format
	-- 			-- `bufnr` and `filter` is handled by the LazyVim formatter,
	-- 			-- but can be also overridden when specified
	-- 			format = {
	-- 				formatting_options = nil,
	-- 				timeout_ms = nil,
	-- 			},
	-- 			-- LSP Server Settings
	-- 			---@type lspconfig.options
	-- 			servers = {
	-- 				lua_ls = {
	-- 					-- mason = false, -- set to false if you don't want this server to be installed with mason
	-- 					-- Use this to add any additional keymaps
	-- 					-- for specific lsp servers
	-- 					-- ---@type LazyKeysSpec[]
	-- 					-- keys = {},
	-- 					settings = {
	-- 						Lua = {
	-- 							workspace = {
	-- 								checkThirdParty = false,
	-- 							},
	-- 							codeLens = {
	-- 								enable = true,
	-- 							},
	-- 							completion = {
	-- 								callSnippet = "Replace",
	-- 							},
	-- 							doc = {
	-- 								privateName = { "^_" },
	-- 							},
	-- 							hint = {
	-- 								enable = true,
	-- 								setType = false,
	-- 								paramType = true,
	-- 								paramName = "Disable",
	-- 								semicolon = "Disable",
	-- 								arrayIndex = "Disable",
	-- 							},
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			-- you can do any additional lsp server setup here
	-- 			-- return true if you don't want this server to be setup with lspconfig
	-- 			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
	-- 			setup = {
	-- 				-- example to setup with typescript.nvim
	-- 				-- tsserver = function(_, opts)
	-- 				--   require("typescript").setup({ server = opts })
	-- 				--   return true
	-- 				-- end,
	-- 				-- Specify * to use this function as a fallback for any server
	-- 				-- ["*"] = function(server, opts) end,
	-- 			},
	-- 		}
	-- 		return ret
	-- 	end,
	-- 	---@param opts PluginLspOpts
	-- 	config = function(_, opts)
	-- 		-- setup autoformat
	-- 		LazyVim.format.register(LazyVim.lsp.formatter())

	-- 		-- setup keymaps
	-- 		LazyVim.lsp.on_attach(function(client, buffer)
	-- 			require("plugins.lsp.keymaps").on_attach(client, buffer)
	-- 		end)

	-- 		LazyVim.lsp.setup()
	-- 		LazyVim.lsp.on_dynamic_capability(require("plugins.lsp.keymaps").on_attach)

	-- 		-- diagnostics signs
	-- 		if vim.fn.has("nvim-0.10.0") == 0 then
	-- 			if type(opts.diagnostics.signs) ~= "boolean" then
	-- 				for severity, icon in pairs(opts.diagnostics.signs.text) do
	-- 					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
	-- 					name = "DiagnosticSign" .. name
	-- 					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
	-- 				end
	-- 			end
	-- 		end

	-- 		if vim.fn.has("nvim-0.10") == 1 then
	-- 			-- inlay hints
	-- 			if opts.inlay_hints.enabled then
	-- 				LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
	-- 					if
	-- 						vim.api.nvim_buf_is_valid(buffer)
	-- 						and vim.bo[buffer].buftype == ""
	-- 						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
	-- 					then
	-- 						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
	-- 					end
	-- 				end)
	-- 			end

	-- 			-- code lens
	-- 			if opts.codelens.enabled and vim.lsp.codelens then
	-- 				LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
	-- 					vim.lsp.codelens.refresh()
	-- 					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	-- 						buffer = buffer,
	-- 						callback = vim.lsp.codelens.refresh,
	-- 					})
	-- 				end)
	-- 			end
	-- 		end

	-- 		if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
	-- 			opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
	-- 				or function(diagnostic)
	-- 					local icons = LazyVim.config.icons.diagnostics
	-- 					for d, icon in pairs(icons) do
	-- 						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
	-- 							return icon
	-- 						end
	-- 					end
	-- 				end
	-- 		end

	-- 		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

	-- 		local servers = opts.servers
	-- 		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	-- 		local has_blink, blink = pcall(require, "blink.cmp")
	-- 		local capabilities = vim.tbl_deep_extend(
	-- 			"force",
	-- 			{},
	-- 			vim.lsp.protocol.make_client_capabilities(),
	-- 			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
	-- 			has_blink and blink.get_lsp_capabilities() or {},
	-- 			opts.capabilities or {}
	-- 		)

	-- 		local function setup(server)
	-- 			local server_opts = vim.tbl_deep_extend("force", {
	-- 				capabilities = vim.deepcopy(capabilities),
	-- 			}, servers[server] or {})
	-- 			if server_opts.enabled == false then
	-- 				return
	-- 			end

	-- 			if opts.setup[server] then
	-- 				if opts.setup[server](server, server_opts) then
	-- 					return
	-- 				end
	-- 			elseif opts.setup["*"] then
	-- 				if opts.setup["*"](server, server_opts) then
	-- 					return
	-- 				end
	-- 			end
	-- 			require("lspconfig")[server].setup(server_opts)
	-- 		end

	-- 		-- get all the servers that are available through mason-lspconfig
	-- 		local have_mason, mlsp = pcall(require, "mason-lspconfig")
	-- 		local all_mslp_servers = {}
	-- 		if have_mason then
	-- 			all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
	-- 		end

	-- 		local ensure_installed = {} ---@type string[]
	-- 		for server, server_opts in pairs(servers) do
	-- 			if server_opts then
	-- 				server_opts = server_opts == true and {} or server_opts
	-- 				if server_opts.enabled ~= false then
	-- 					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
	-- 					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
	-- 						setup(server)
	-- 					else
	-- 						ensure_installed[#ensure_installed + 1] = server
	-- 					end
	-- 				end
	-- 			end
	-- 		end

	-- 		if have_mason then
	-- 			mlsp.setup({
	-- 				ensure_installed = vim.tbl_deep_extend(
	-- 					"force",
	-- 					ensure_installed,
	-- 					LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
	-- 				),
	-- 				handlers = { setup },
	-- 			})
	-- 		end

	-- 		if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
	-- 			local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
	-- 			LazyVim.lsp.disable("vtsls", is_deno)
	-- 			LazyVim.lsp.disable("denols", function(root_dir, config)
	-- 				if not is_deno(root_dir) then
	-- 					config.settings.deno.enable = false
	-- 				end
	-- 				return false
	-- 			end)
	-- 		end
	-- 	end,
	-- },

	-- -- cmdline tools and lsp servers
	-- {

	-- 	"mason-org/mason.nvim",
	-- 	cmd = "Mason",
	-- 	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
	-- 	build = ":MasonUpdate",
	-- 	opts_extend = { "ensure_installed" },
	-- 	opts = {
	-- 		ensure_installed = {
	-- 			"stylua",
	-- 			"shfmt",
	-- 		},
	-- 	},
	-- 	---@param opts MasonSettings | {ensure_installed: string[]}
	-- 	config = function(_, opts)
	-- 		require("mason").setup(opts)
	-- 		local mr = require("mason-registry")
	-- 		mr:on("package:install:success", function()
	-- 			vim.defer_fn(function()
	-- 				-- trigger FileType event to possibly load this newly installed LSP server
	-- 				require("lazy.core.handler.event").trigger({
	-- 					event = "FileType",
	-- 					buf = vim.api.nvim_get_current_buf(),
	-- 				})
	-- 			end, 100)
	-- 		end)

	-- 		mr.refresh(function()
	-- 			for _, tool in ipairs(opts.ensure_installed) do
	-- 				local p = mr.get_package(tool)
	-- 				if not p:is_installed() then
	-- 					p:install()
	-- 				end
	-- 			end
	-- 		end)
	-- 	end,
	-- },

	-- -- pin to v1 for now
	-- { "mason-org/mason.nvim", version = "^1.0.0" },
	-- { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
