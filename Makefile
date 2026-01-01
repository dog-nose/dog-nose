SHELL := /bin/bash
.PHONY: setup help verify

# デフォルトターゲット
.DEFAULT_GOAL := setup

# ヘルプ
help:
	@echo "利用可能なコマンド:"
	@echo "  make setup  - 初期セットアップを実行"
	@echo "  make verify - セットアップの検証を実行"
	@echo "  make help   - このヘルプを表示"

# セットアップ
setup:
	@echo "=== セットアップを開始します ==="
	@$(MAKE) link-config
	@$(MAKE) setup-zshrc
	@$(MAKE) setup-gitconfig
	@echo "=== セットアップが完了しました ==="
	@echo ""
	@echo "セットアップの検証を実行するには: make verify"

# セットアップの検証
verify:
	@bash tests/verify-setup.sh

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
	@if [ -f "$$HOME/.gitconfig" ]; then \
		echo "既存の ~/.gitconfig が見つかりました"; \
		read -p "バックアップして新規作成しますか？ (b: バックアップ, d: 削除, s: スキップ) [b/d/s]: " answer; \
		case "$$answer" in \
			b|B) \
				cp "$$HOME/.gitconfig" "$$HOME/.gitconfig.backup.$$(date +%Y%m%d_%H%M%S)"; \
				echo "✓ バックアップを作成しました"; \
				read -p "Git ユーザー名を入力してください: " git_name; \
				read -p "Git メールアドレスを入力してください: " git_email; \
				echo "[user]" > "$$HOME/.gitconfig"; \
				echo "    name = $$git_name" >> "$$HOME/.gitconfig"; \
				echo "    email = $$git_email" >> "$$HOME/.gitconfig"; \
				echo "" >> "$$HOME/.gitconfig"; \
				echo "[include]" >> "$$HOME/.gitconfig"; \
				echo "    path = ~/.config/git/00-common.gitconfig" >> "$$HOME/.gitconfig"; \
				echo "✓ ~/.gitconfig を新規作成しました"; \
				;; \
			d|D) \
				rm "$$HOME/.gitconfig"; \
				echo "✓ 既存の ~/.gitconfig を削除しました"; \
				read -p "Git ユーザー名を入力してください: " git_name; \
				read -p "Git メールアドレスを入力してください: " git_email; \
				echo "[user]" > "$$HOME/.gitconfig"; \
				echo "    name = $$git_name" >> "$$HOME/.gitconfig"; \
				echo "    email = $$git_email" >> "$$HOME/.gitconfig"; \
				echo "" >> "$$HOME/.gitconfig"; \
				echo "[include]" >> "$$HOME/.gitconfig"; \
				echo "    path = ~/.config/git/00-common.gitconfig" >> "$$HOME/.gitconfig"; \
				echo "✓ ~/.gitconfig を新規作成しました"; \
				;; \
			s|S|*) \
				echo "✓ ~/.gitconfig のセットアップをスキップしました"; \
				;; \
		esac \
	else \
		echo "[include]" >> "$$HOME/.gitconfig"; \
		echo "    path = ~/.config/git/00-common.gitconfig" >> "$$HOME/.gitconfig"; \
		echo "" >> "$$HOME/.gitconfig"; \
		read -p "Git ユーザー名を入力してください: " git_name; \
		read -p "Git メールアドレスを入力してください: " git_email; \
		echo "[user]" > "$$HOME/.gitconfig"; \
		echo "    name = $$git_name" >> "$$HOME/.gitconfig"; \
		echo "    email = $$git_email" >> "$$HOME/.gitconfig"; \
		echo "✓ ~/.gitconfig を作成しました"; \
	fi
