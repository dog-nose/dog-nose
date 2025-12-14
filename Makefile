SHELL := /bin/bash
.PHONY: init update test clean backup docker-build docker-test health-check help link-claude-commands

# プラットフォーム検出
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	DISTRO := $(shell lsb_release -si 2>/dev/null || echo "Unknown")
endif

# パッケージマネージャー検出
define detect_package_manager
	$(shell \
		if command -v apt-get >/dev/null 2>&1; then \
			echo "apt"; \
		elif command -v brew >/dev/null 2>&1; then \
			echo "brew"; \
		elif command -v yum >/dev/null 2>&1; then \
			echo "yum"; \
		elif command -v pacman >/dev/null 2>&1; then \
			echo "pacman"; \
		else \
			echo "unknown"; \
		fi \
	)
endef

PACKAGE_MANAGER := $(detect_package_manager)

# デフォルトターゲット
help:
	@echo "PC Setup Repository - Available Commands:"
	@echo "  init                - 初期セットアップ（必要なツールのインストール、設定ファイルのリンク）"
	@echo "  update              - 更新処理（oh-my-zsh、プラグイン、neovimの更新）"
	@echo "  test                - 動作確認（zsh、neovim、LSP設定の確認）"
	@echo "  clean               - 環境クリーンアップ（古いリンクや不要なファイルの削除）"
	@echo "  backup              - 既存設定のバックアップ作成"
	@echo "  health-check        - 健全性チェック（各ツールのバージョン確認）"
	@echo "  link-claude-commands - Claude Codeコマンドのシンボリックリンク作成"
	@echo "  docker-build        - Dockerイメージのビルド"
	@echo "  docker-test         - Docker環境でのテスト実行"
	@echo "  help                - このヘルプメッセージを表示"

# 初期セットアップ
init: backup
	@echo "=== PC Setup Repository 初期セットアップ開始 ==="
	@$(MAKE) install-tools
	@$(MAKE) install-oh-my-zsh
	@$(MAKE) link-configs
	@$(MAKE) link-claude-commands
	@$(MAKE) install-plugins
	@echo "=== 初期セットアップ完了 ==="

# 必要なツールのインストール
install-tools:
	@echo ">>> 必要なツールのインストール..."
	@if [ "$(PACKAGE_MANAGER)" = "apt" ]; then \
		sudo apt-get update && sudo apt-get install -y zsh git curl wget build-essential nodejs npm; \
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz; \
		sudo tar -C /opt -xzf nvim-linux64.tar.gz; \
		sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim; \
		rm -f nvim-linux64.tar.gz; \
		curl -L https://github.com/x-motemen/ghq/releases/latest/download/ghq_linux_amd64.tar.gz | tar -C /tmp -xzf -; \
		sudo mv /tmp/ghq_linux_amd64/ghq /usr/local/bin/ghq; \
		sudo chmod +x /usr/local/bin/ghq; \
	elif [ "$(PACKAGE_MANAGER)" = "brew" ]; then \
		brew install zsh git neovim node ghq; \
	elif [ "$(PACKAGE_MANAGER)" = "yum" ]; then \
		sudo yum install -y zsh git curl wget gcc gcc-c++ make nodejs npm; \
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz; \
		sudo tar -C /opt -xzf nvim-linux64.tar.gz; \
		sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim; \
		rm -f nvim-linux64.tar.gz; \
		curl -L https://github.com/x-motemen/ghq/releases/latest/download/ghq_linux_amd64.tar.gz | tar -C /tmp -xzf -; \
		sudo mv /tmp/ghq_linux_amd64/ghq /usr/local/bin/ghq; \
		sudo chmod +x /usr/local/bin/ghq; \
	else \
		echo "未サポートのパッケージマネージャーです: $(PACKAGE_MANAGER)"; \
		echo "手動でzsh, git, neovim, node, ghqをインストールしてください"; \
		exit 1; \
	fi

# oh-my-zshのインストール
install-oh-my-zsh:
	@echo ">>> oh-my-zshのインストール..."
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	else \
		echo "oh-my-zsh は既にインストールされています"; \
	fi

# 設定ファイルのリンク
link-configs:
	@echo ">>> 設定ファイルのリンク作成..."
	@ln -sf $(CURDIR)/config ~/.config
	@if [ -f "$(CURDIR)/template/default.zsh" ]; then \
		cp $(CURDIR)/template/default.zsh ~/.zshrc; \
	fi
	@echo "設定ファイルのリンクが完了しました"

# Claude Codeコマンドのリンク
link-claude-commands:
	@echo ">>> Claude Code commands のリンク作成..."
	@mkdir -p ~/.claude/commands
	@ln -sf $(CURDIR)/.claude/commands/* ~/.claude/commands/
	@echo "Claude Code commands のリンクが完了しました"

# プラグインのインストール
install-plugins:
	@echo ">>> zshプラグインのインストール..."
	@mkdir -p ~/.oh-my-zsh/custom/plugins
	@if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-completions" ]; then \
		git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions; \
	fi
	@if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	fi
	@if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	fi

# 更新処理
update:
	@echo "=== 更新処理開始 ==="
	@$(MAKE) update-oh-my-zsh
	@$(MAKE) update-plugins
	@$(MAKE) update-neovim
	@$(MAKE) link-configs
	@echo "=== 更新処理完了 ==="

# oh-my-zshの更新
update-oh-my-zsh:
	@echo ">>> oh-my-zshの更新..."
	@if [ -d "$$HOME/.oh-my-zsh" ]; then \
		cd ~/.oh-my-zsh && git pull; \
	fi

# プラグインの更新
update-plugins:
	@echo ">>> プラグインの更新..."
	@for plugin in zsh-completions zsh-autosuggestions zsh-syntax-highlighting; do \
		if [ -d "$$HOME/.oh-my-zsh/custom/plugins/$$plugin" ]; then \
			cd "$$HOME/.oh-my-zsh/custom/plugins/$$plugin" && git pull; \
		fi; \
	done

# neovimの更新
update-neovim:
	@echo ">>> neovimの更新確認..."
	@if command -v nvim >/dev/null 2>&1; then \
		echo "現在のneovimバージョン: $$(nvim --version | head -1)"; \
		echo "最新版の確認は手動で行ってください"; \
	fi

# 動作確認テスト
test:
	@echo "=== 動作確認テスト開始 ==="
	@$(MAKE) test-zsh
	@$(MAKE) test-neovim
	@$(MAKE) test-configs
	@echo "=== 動作確認テスト完了 ==="

# zshの動作確認
test-zsh:
	@echo ">>> zshの動作確認..."
	@if command -v zsh >/dev/null 2>&1; then \
		echo "✓ zsh is installed: $$(zsh --version)"; \
	else \
		echo "✗ zsh is not installed"; \
		exit 1; \
	fi
	@if [ -d "$$HOME/.oh-my-zsh" ]; then \
		echo "✓ oh-my-zsh is installed"; \
	else \
		echo "✗ oh-my-zsh is not installed"; \
		exit 1; \
	fi

# neovimの動作確認
test-neovim:
	@echo ">>> neovimの動作確認..."
	@if command -v nvim >/dev/null 2>&1; then \
		echo "✓ neovim is installed: $$(nvim --version | head -1)"; \
		echo "✓ neovim起動テスト..."; \
		timeout 5 nvim --headless -c 'echo "neovim OK"' -c 'qall!' || echo "neovim起動確認完了"; \
	else \
		echo "✗ neovim is not installed"; \
		exit 1; \
	fi

# 設定ファイルの確認
test-configs:
	@echo ">>> 設定ファイルの確認..."
	@if [ -L "$$HOME/.config" ]; then \
		echo "✓ ~/.config is linked to $(CURDIR)/config"; \
	else \
		echo "✗ ~/.config is not properly linked"; \
		exit 1; \
	fi
	@if [ -f "$$HOME/.zshrc" ]; then \
		echo "✓ ~/.zshrc exists"; \
	else \
		echo "✗ ~/.zshrc does not exist"; \
		exit 1; \
	fi

# 環境クリーンアップ
clean:
	@echo ">>> 環境クリーンアップ..."
	@if [ -L "$$HOME/.config" ]; then \
		rm -f ~/.config; \
		echo "✓ ~/.config リンクを削除しました"; \
	fi
	@echo "クリーンアップ完了"

# バックアップ作成
backup:
	@echo ">>> 既存設定のバックアップ作成..."
	@if [ -f "$$HOME/.zshrc" ] && [ ! -L "$$HOME/.zshrc" ]; then \
		cp ~/.zshrc ~/.zshrc.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "✓ ~/.zshrc をバックアップしました"; \
	fi
	@if [ -e "$$HOME/.config" ] && [ ! -L "$$HOME/.config" ]; then \
		mv ~/.config ~/.config.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "✓ ~/.config をバックアップしました"; \
	fi

# 健全性チェック
health-check:
	@echo "=== 健全性チェック ==="
	@echo "OS: $(UNAME_S)"
	@echo "パッケージマネージャー: $(PACKAGE_MANAGER)"
	@echo ""
	@echo ">>> インストール済みツールの確認..."
	@for tool in zsh git nvim node ghq; do \
		if command -v $$tool >/dev/null 2>&1; then \
			echo "✓ $$tool: $$($$tool --version 2>/dev/null | head -1 || echo 'インストール済み')"; \
		else \
			echo "✗ $$tool: 未インストール"; \
		fi; \
	done
	@echo ""
	@echo ">>> 設定ファイルの確認..."
	@if [ -L "$$HOME/.config" ]; then \
		echo "✓ ~/.config -> $$(readlink ~/.config)"; \
	else \
		echo "✗ ~/.config が正しくリンクされていません"; \
	fi

# Docker関連
docker-build:
	@echo ">>> Dockerイメージをビルド中..."
	@docker build -t dotfiles-ubuntu .

docker-test:
	@echo ">>> Docker環境でテスト実行中..."
	@docker run --rm -it dotfiles-ubuntu /bin/bash -c "make test"