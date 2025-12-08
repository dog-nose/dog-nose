return {
	{
		-- 整形
		"kg8m/vim-simple-align",
	},
	{
		-- eidtorconfig
		"editorconfig/editorconfig-vim",
	},

	{
		"echasnovski/mini.pairs",
		version = false,
		config = function()
			require("mini.pairs").setup({})
		end,
	},
  {
    'duane9/nvim-rg',
    config = function()
      vim.g.rg_command = "rg --vimgrep --smart-case --hidden"
      vim.g.rg_map_keys = 0

      vim.keymap.set("n", "<leader>rg", ":Rg<Space>")
      vim.keymap.set("n", "<leader>rw", ":Rg <C-r><C-w><CR>")

    end
  }
}
