return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function my_on_attach(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- custom mappings
				-- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
				vim.keymap.set("n", "t", api.fs.create, opts("Create File Or Directory"))
				vim.keymap.del("n", "<C-e>", { buffer = bufnr })
				vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			end

			require("nvim-tree").setup({
				on_attach = my_on_attach,
				sort = {
					sorter = "name",
					folders_first = true,
				},
				git = {
					enable = true,
					ignore = false,
				},
				view = {
					width = 30,
				},
				renderer = {
					highlight_git = true,
					highlight_opened_files = "none",
					group_empty = true,
					indent_markers = {
						enable = true,
						inline_arrows = false,
						icons = {
							corner = "└",
							edge = "│",
							item = "├",
							bottom = "─",
							none = " ",
						},
					},
					icons = {
						web_devicons = {
							file = {
								enable = true,
								color = true,
							},
							folder = {
								enable = false,
								color = true,
							},
						},
						show = {
							folder_arrow = false,
						},
						glyphs = {
							default = "",
							symlink = "",
							bookmark = "󰆤",
							modified = "●",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "",
								staged = "",
								unmerged = "",
								renamed = "",
								untracked = "",
								deleted = "",
								ignored = "",
							},
						},
					},
				},
				filters = {
					dotfiles = false,
				},
			})

			vim.keymap.set("n", "<C-e>", "<Cmd>NvimTreeToggle<CR>")
			vim.keymap.set("n", "<Leader>e", "<Cmd>NvimTreeFindFile<CR>")
		end,
	},
}
