#!/bin/bash

# セットアップ検証スクリプト
# make setup で作成されたファイルとリンクが正しく設定されているかチェックします

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# カウンター
ERRORS=0
WARNINGS=0
CHECKS=0

# ヘルパー関数
print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
    ((CHECKS++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_info() {
    echo -e "  $1"
}

# リポジトリルートディレクトリの取得
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# シンボリックリンクの検証
check_symlinks() {
    print_header "シンボリックリンクの検証"

    if [ -L "$HOME/.config" ]; then
        local link_target=$(readlink "$HOME/.config")
        local expected_target="$REPO_ROOT/config"

        if [ "$link_target" = "$expected_target" ]; then
            print_success "~/.config は正しいパスにリンクされています"
            print_info "リンク先: $link_target"
        else
            print_error "~/.config のリンク先が正しくありません"
            print_info "期待値: $expected_target"
            print_info "実際の値: $link_target"
        fi
    elif [ -e "$HOME/.config" ]; then
        print_error "~/.config はシンボリックリンクではありません（通常のディレクトリまたはファイル）"
    else
        print_error "~/.config が存在しません"
    fi
}

# .zshrcの検証
check_zshrc() {
    print_header ".zshrcの検証"

    if [ -f "$HOME/.zshrc" ]; then
        print_success "~/.zshrc が存在します"

        # 必要な内容が含まれているかチェック
        if grep -q "\.config/zsh/\[0-9\]\[0-9\]-\*.zsh" "$HOME/.zshrc"; then
            print_success "~/.zshrc に設定ファイル読み込み処理が含まれています"
        else
            print_warning "~/.zshrc に設定ファイル読み込み処理が見つかりません"
            print_info "以下の内容が必要です："
            print_info "  for config_file in ~/.config/zsh/[0-9][0-9]-*.zsh; do"
            print_info "      source \"\$config_file\""
            print_info "  done"
        fi
    else
        print_error "~/.zshrc が存在しません"
    fi
}

# .gitconfigの検証
check_gitconfig() {
    print_header ".gitconfigの検証"

    if [ -f "$HOME/.gitconfig" ]; then
        print_success "~/.gitconfig が存在します"

        # includeパスのチェック
        if grep -q "path = ~/.config/git/00-common.gitconfig" "$HOME/.gitconfig" || \
           grep -q 'path = "~/.config/git/00-common.gitconfig"' "$HOME/.gitconfig"; then
            print_success "~/.gitconfig に正しいincludeパスが設定されています"
        else
            print_warning "~/.gitconfig にincludeパスが見つかりません"
            print_info "以下の内容が必要です："
            print_info "  [include]"
            print_info "      path = ~/.config/git/00-common.gitconfig"
        fi

        # user設定のチェック
        if grep -q "\[user\]" "$HOME/.gitconfig"; then
            print_success "~/.gitconfig にuser設定が含まれています"
        else
            print_warning "~/.gitconfig にuser設定が見つかりません"
        fi
    else
        print_error "~/.gitconfig が存在しません"
    fi
}

# 必須設定ファイルの存在確認
check_config_files() {
    print_header "必須設定ファイルの確認"

    local config_files=(
        "$REPO_ROOT/config/zsh"
        "$REPO_ROOT/config/git/00-common.gitconfig"
        "$REPO_ROOT/config/nvim-lazy"
        "$REPO_ROOT/config/nvim-my"
    )

    for file in "${config_files[@]}"; do
        if [ -e "$file" ]; then
            print_success "$(basename "$file") が存在します"
        else
            print_error "$(basename "$file") が見つかりません: $file"
        fi
    done

    # zsh設定ファイルの存在確認
    local zsh_configs=("$REPO_ROOT"/config/zsh/[0-9][0-9]-*.zsh)
    if [ -e "${zsh_configs[0]}" ]; then
        local count=$(ls -1 "$REPO_ROOT"/config/zsh/[0-9][0-9]-*.zsh 2>/dev/null | wc -l)
        print_success "Zsh設定ファイル: ${count}個 見つかりました"
    else
        print_warning "Zsh設定ファイル (NN-*.zsh) が見つかりません"
    fi
}

# メイン実行
main() {
    echo -e "${BLUE}"
    echo "======================================"
    echo "  セットアップ検証スクリプト"
    echo "======================================"
    echo -e "${NC}"
    echo ""

    check_symlinks
    echo ""
    check_zshrc
    echo ""
    check_gitconfig
    echo ""
    check_config_files
    echo ""

    # 結果サマリー
    print_header "検証結果"
    echo -e "総チェック数: ${CHECKS}"
    echo -e "${GREEN}成功: $((CHECKS - ERRORS))${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}警告: ${WARNINGS}${NC}"
    fi
    if [ $ERRORS -gt 0 ]; then
        echo -e "${RED}エラー: ${ERRORS}${NC}"
    fi
    echo ""

    if [ $ERRORS -eq 0 ]; then
        echo -e "${GREEN}✓ すべてのチェックに合格しました！${NC}"
        exit 0
    else
        echo -e "${RED}✗ エラーが見つかりました。上記の内容を確認してください。${NC}"
        exit 1
    fi
}

# スクリプト実行
main
