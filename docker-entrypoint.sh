#!/bin/bash

set -e

echo "=== Docker Environment Setup ==="
echo "Ubuntu $(lsb_release -rs)"
echo "Working directory: $(pwd)"

# ghqでリポジトリをクローンする場合の設定
if [ "$SETUP_WITH_GHQ" = "true" ]; then
    echo ">>> Setting up with ghq..."
    
    # ghqの設定
    mkdir -p ~/.config/ghq
    cat > ~/.config/ghq/config.toml << EOF
[ghq]
    root = "~/src"
EOF
    
    # ghqでリポジトリをクローン（シミュレーション）
    mkdir -p ~/src/github.com/dog-nose
    cp -r /workspace ~/src/github.com/dog-nose/dog-nose
    cd ~/src/github.com/dog-nose/dog-nose
    
    echo "✓ Repository cloned with ghq simulation"
else
    echo ">>> Using current workspace..."
    cd /workspace
fi

# 初期セットアップの実行
echo ">>> Running initial setup..."
if [ "$RUN_INIT" = "true" ]; then
    make init
    echo "✓ Initial setup completed"
fi

# テストの実行
if [ "$RUN_TEST" = "true" ]; then
    echo ">>> Running tests..."
    make test
    echo "✓ Tests completed"
fi

# 健全性チェック
if [ "$RUN_HEALTH_CHECK" = "true" ]; then
    echo ">>> Running health check..."
    make health-check
    echo "✓ Health check completed"
fi

echo "=== Docker Environment Ready ==="

# 引数が渡された場合はそれを実行、そうでなければシェルを起動
if [ $# -eq 0 ]; then
    exec /bin/bash
else
    exec "$@"
fi