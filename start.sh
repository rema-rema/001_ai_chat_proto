#!/bin/bash

# Fly.io アプリケーション起動スクリプト

echo "🚀 Fly.io アプリケーションを起動します..."

# マシン数を1に設定
flyctl scale count 1

# ステータス確認
echo "📊 アプリケーションのステータス:"
flyctl status

# ログ監視（オプション）
read -p "ログを監視しますか？ (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "📋 ログ監視を開始します（Ctrl+C で終了）:"
    flyctl logs
fi

echo "✅ アプリケーションが起動しました"
echo "🌐 アプリケーションを開くには: flyctl open"