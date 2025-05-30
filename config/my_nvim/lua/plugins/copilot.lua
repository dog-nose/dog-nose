return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			-- Copilotのタブマッピングを無効にする
			vim.g.copilot_no_tab_map = true
			-- 挿入モードで<C-J>をcopilot#Accept()にマッピングする
			vim.api.nvim_set_keymap("i", "<C-J>", "copilot#Accept()", { expr = true, silent = true, script = true })
		end,
	},
	-- TODO copilot chat
}
