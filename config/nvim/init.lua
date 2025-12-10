vim.scriptencoding = "utf-8"
vim.g.mapleader = " "

if not vim.g.vscode then
	require("config.lazy")
end
-- hoge

local options = {
	syntax = "on",
	number = true,
	relativenumber = true,
	showcmd = true,
	cursorline = true,
	numberwidth = 6,
	autoindent = true,
	hlsearch = true,
	wrapscan = true,
	ignorecase = true,
	smartcase = true,
	clipboard = "unnamedplus",
	backup = false,
	writebackup = false,
	swapfile = false,
	expandtab = true,
	shiftwidth = 4,
	tabstop = 4,
	backspace = "indent,eol,start",
	list = true,
	listchars = "tab:>.,trail:_,extends:>,precedes:<,nbsp:%,space:.",
	wildmenu = true,
	laststatus = 2,
	splitbelow = true,
	splitright = true,
	termguicolors = true,
	signcolumn = "yes:1",
	compatible = false,
	scrolloff = 5,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

if vim.g.vscode then
	return
end

vim.opt.wildignore:append({ "*.pyc", ".git/**", "vendor/**", "bundle/**" })

-- autocmd
local autocmd = vim.api.nvim_create_autocmd
autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
	end,
})
-- keymap
local keymap = vim.keymap

-- filetype
local file_type_settings = {
	{ pattern = "lua", command = "setlocal sw=2 sts=2 ts=2 expandtab colorcolumn=120" },
	{ pattern = "html", command = "setlocal sw=2 sts=2 ts=2 et colorcolumn=80" },
	{ pattern = "php", command = "setlocal sw=4 sts=4 ts=4 et colorcolumn=120" },
	{ pattern = "sql", command = "setlocal sw=2 sts=2 ts=2 et colorcolumn=80" },
}
for _, setting in ipairs(file_type_settings) do
	autocmd("FileType", setting)
end

-- キーマップ
--- カーソル移動時に中央に移動させる
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")
keymap.set("n", "*", "*zz")
keymap.set("n", "g*", "g*zz")
keymap.set("n", "g#", "g#zz")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-n>", "<Cmd>cn<CR>zz")
keymap.set("n", "<C-p>", "<Cmd>cp<CR>zz")
keymap.set("n", "<C-o>", "<C-o>zz")
keymap.set("n", "<C-i>", "<C-i>zz")
--- タブの移動
keymap.set("n", "{", "<Cmd>tabprevious<CR>")
keymap.set("n", "}", "<Cmd>tabnext<CR>")
--- 画面分割時の移動
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-l>", "<C-w>l")
--- ファイル作成
keymap.set("n", "<leader>n", "<Cmd>split +enew<CR>")
keymap.set("n", "<leader>t", "<Cmd>tabnew<CR>")
--- カッコのくくり
keymap.set("n", "<leader>s'", "ciw''<Esc>P")
keymap.set("n", '<leader>s"', 'ciw""<Esc>P')
keymap.set("n", "<leader>s`", "ciw``<Esc>P")
keymap.set("n", "<leader>s(", "ciw()<Esc>P")
keymap.set("n", "<leader>s{", "ciw{}<Esc>P")
keymap.set("n", "<leader>s[", "ciw[]<Esc>P")
--- lsp
keymap.set("n", "<Leader>/", "<Cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<Leader><Leader>", "<Cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<Leader>r", "<Cmd>lua vim.lsp.buf.references()<CR>")

keymap.set("n", "tt", "<cmd>Terminal<CR>")
keymap.set("n", "<leader>m", "<Cmd>Markview Toggle<CR>")

-- terminalを開く時の制御
local function open_terminal()
	local term_bufnr = nil
	-- 現在のバッファのリストを取得
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buftype == "terminal" then
			term_bufnr = bufnr
			break
		end
	end

	if term_bufnr then
		-- 既存のターミナルバッファを開く
		vim.cmd("buffer " .. term_bufnr)
	else
		-- 新しいターミナルバッファを作成
		vim.cmd("terminal")
	end
end
vim.api.nvim_create_user_command("Terminal", open_terminal, {})

-- ダブルバイトスペースを強調表示
local function DoubleByteSpace()
	vim.api.nvim_set_hl(0, "DoubleByteSpace", { bg = "darkgray" })
end
if vim.fn.has("syntax") == 1 then
	vim.api.nvim_create_augroup("DoubleByteSpace", { clear = true })

	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		group = "DoubleByteSpace",
		callback = DoubleByteSpace,
	})

	vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufRead" }, {
		group = "DoubleByteSpace",
		callback = function()
			vim.fn.matchadd("DoubleByteSpace", "　")
		end,
	})

	DoubleByteSpace()
end

-- フォーマットを実行するカスタムコマンドを作成
vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format the current buffer using LSP" })

if vim.fn.executable("nvr") == 1 then
	vim.env.EDITOR = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'
end

if vim.fn.executable("rg") == 1 then
	vim.o.grepprg = "rg --vimgrep --hidden"
	vim.o.grepformat = "%f:%l:%c:%m"
end

vim.keymap.set("t", "zj", [[<C-\><C-n>]])
