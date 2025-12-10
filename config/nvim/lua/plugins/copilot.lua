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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  }
}
