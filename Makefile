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
	@if [ -f "$$HOME/.zshrc" ]; then \
		echo "既存の ~/.zshrc が見つかりました"; \
		read -p "バックアップして新規作成しますか？ (b: バックアップ, d: 削除, s: スキップ) [b/d/s]: " answer; \
		case "$$answer" in \
			b|B) \
				cp "$$HOME/.zshrc" "$$HOME/.zshrc.backup.$$(date +%Y%m%d_%H%M%S)"; \
				echo "✓ バックアップを作成しました"; \
				echo "# Load zsh configuration files" > "$$HOME/.zshrc"; \
				echo "for config_file in ~/.config/zsh/[0-9][0-9]-*.zsh; do" >> "$$HOME/.zshrc"; \
				echo "    source \"\$$config_file\"" >> "$$HOME/.zshrc"; \
				echo "done" >> "$$HOME/.zshrc"; \
				echo "✓ ~/.zshrc を新規作成しました"; \
				;; \
			d|D) \
				rm "$$HOME/.zshrc"; \
				echo "✓ 既存の ~/.zshrc を削除しました"; \
				echo "# Load zsh configuration files" > "$$HOME/.zshrc"; \
				echo "for config_file in ~/.config/zsh/[0-9][0-9]-*.zsh; do" >> "$$HOME/.zshrc"; \
				echo "    source \"\$$config_file\"" >> "$$HOME/.zshrc"; \
				echo "done" >> "$$HOME/.zshrc"; \
				echo "✓ ~/.zshrc を新規作成しました"; \
				;; \
			s|S|*) \
				echo "✓ ~/.zshrc のセットアップをスキップしました"; \
				;; \
		esac \
	else \
		echo "# Load zsh configuration files" > "$$HOME/.zshrc"; \
		echo "for config_file in ~/.config/zsh/[0-9][0-9]-*.zsh; do" >> "$$HOME/.zshrc"; \
		echo "    source \"\$$config_file\"" >> "$$HOME/.zshrc"; \
		echo "done" >> "$$HOME/.zshrc"; \
		echo "✓ ~/.zshrc を作成しました"; \
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
