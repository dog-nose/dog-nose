#!/bin/bash

# PC Setup Repository の統合テストスクリプト
# このスクリプトは Docker 環境で実行され、全体の動作を検証します

set -e

echo "=== PC Setup Repository 統合テスト開始 ==="

# テスト結果を記録
TEST_RESULTS=()
FAILED_TESTS=()

# テスト関数
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo ">>> テスト実行: $test_name"
    
    if eval "$test_command"; then
        echo "✓ $test_name: 成功"
        TEST_RESULTS+=("✓ $test_name: 成功")
    else
        echo "✗ $test_name: 失敗"
        TEST_RESULTS+=("✗ $test_name: 失敗")
        FAILED_TESTS+=("$test_name")
    fi
    echo ""
}

# 1. 基本ツールのインストールテスト
run_test "基本ツールのインストール" "make install-tools"

# 2. oh-my-zshのインストールテスト
run_test "oh-my-zshのインストール" "make install-oh-my-zsh"

# 3. 設定ファイルのリンクテスト
run_test "設定ファイルのリンク" "make link-configs"

# 4. プラグインのインストールテスト
run_test "プラグインのインストール" "make install-plugins"

# 5. 各ツールの動作確認
run_test "zshの動作確認" "make test-zsh"
run_test "neovimの動作確認" "make test-neovim"
run_test "設定ファイルの確認" "make test-configs"

# 6. 健全性チェック
run_test "健全性チェック" "make health-check"

# 7. 更新処理のテスト
run_test "更新処理" "make update"

# 8. ghqのテスト（インストール確認）
run_test "ghqの動作確認" "command -v ghq >/dev/null 2>&1 && ghq --version"

# 9. neovimの起動テスト（詳細）
run_test "neovimの詳細起動テスト" "timeout 10 nvim --headless +qa"

# 10. zshプラグインの確認
run_test "zshプラグインの確認" "test -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && test -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

echo "=== テスト結果サマリー ==="
for result in "${TEST_RESULTS[@]}"; do
    echo "$result"
done

echo ""
echo "実行されたテスト数: ${#TEST_RESULTS[@]}"
echo "失敗したテスト数: ${#FAILED_TESTS[@]}"

if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
    echo "✓ すべてのテストが成功しました！"
    exit 0
else
    echo "✗ 以下のテストが失敗しました:"
    for failed_test in "${FAILED_TESTS[@]}"; do
        echo "  - $failed_test"
    done
    exit 1
fi