SHELL := /bin/bash
.PHONY: setup help

# デフォルトターゲット
.DEFAULT_GOAL := setup

# ヘルプ
help:
	@echo "利用可能なコマンド:"
	@echo "  make setup - 初期セットアップを実行"
	@echo "  make help  - このヘルプを表示"

# セットアップ
setup:
	@echo "=== セットアップを開始します ==="
	@$(MAKE) link-config
	@$(MAKE) setup-zshrc
	@$(MAKE) setup-gitconfig
	@echo "=== セットアップが完了しました ==="

# configディレクトリのシンボリックリンク作成
link-config:
	@echo ">>> configディレクトリのシンボリックリンクを作成..."
	@if [ -e "$$HOME/.config" ] && [ ! -L "$$HOME/.config" ]; then \
		echo "既存の ~/.config をバックアップしています..."; \
		mv "$$HOME/.config" "$$HOME/.config.backup.$$(date +%Y%m%d_%H%M%S)"; \
	fi
	@if [ ! -L "$$HOME/.config" ]; then \
		ln -sf "$(CURDIR)/config" "$$HOME/.config"; \
		echo "✓ ~/.config -> $(CURDIR)/config"; \
	else \
		echo "✓ ~/.config は既にリンクされています"; \
	fi

# .zshrcの作成
setup-zshrc:
	@echo ">>> .zshrcの設定..."
	@if [ ! -f "$$HOME/.zshrc" ]; then \
		echo "# Load custom zsh configuration" > "$$HOME/.zshrc"; \
		echo "source ~/.config/zsh/init.zsh" >> "$$HOME/.zshrc"; \
		echo "✓ ~/.zshrc を作成しました"; \
	else \
		if ! grep -q "source ~/.config/zsh/init.zsh" "$$HOME/.zshrc"; then \
			echo "" >> "$$HOME/.zshrc"; \
			echo "# Load custom zsh configuration" >> "$$HOME/.zshrc"; \
			echo "source ~/.config/zsh/init.zsh" >> "$$HOME/.zshrc"; \
			echo "✓ ~/.zshrc に設定を追加しました"; \
		else \
			echo "✓ ~/.zshrc は既に設定されています"; \
		fi \
	fi

# .gitconfigの作成
setup-gitconfig:
	@echo ">>> Gitの設定..."
	@if [ ! -f "$$HOME/.gitconfig" ]; then \
		echo "[include]" > "$$HOME/.gitconfig"; \
		echo "    path = ~/.config/git/.gitconfig" >> "$$HOME/.gitconfig"; \
		echo "✓ ~/.gitconfig を作成しました"; \
	else \
		if ! grep -q "path = ~/.config/git/.gitconfig" "$$HOME/.gitconfig"; then \
			echo "" >> "$$HOME/.gitconfig"; \
			echo "[include]" >> "$$HOME/.gitconfig"; \
			echo "    path = ~/.config/git/.gitconfig" >> "$$HOME/.gitconfig"; \
			echo "✓ ~/.gitconfig に設定を追加しました"; \
		else \
			echo "✓ ~/.gitconfig は既に設定されています"; \
		fi \
	fi
	@if [ ! -f "$$HOME/.config/git/local.gitconfig" ]; then \
		read -p "Git ユーザー名を入力してください: " git_name; \
		read -p "Git メールアドレスを入力してください: " git_email; \
		echo "[user]" > "$$HOME/.config/git/local.gitconfig"; \
		echo "    name = $$git_name" >> "$$HOME/.config/git/local.gitconfig"; \
		echo "    email = $$git_email" >> "$$HOME/.config/git/local.gitconfig"; \
		echo "✓ Git ユーザー情報を設定しました"; \
	else \
		echo "✓ Git ユーザー情報は既に設定されています"; \
	fi
