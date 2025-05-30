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
}
