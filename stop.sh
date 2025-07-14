#!/bin/bash

# Fly.io アプリケーション停止スクリプト

echo "🛑 Fly.io アプリケーションを停止します..."

# マシン数を0に設定
flyctl scale count 0

# ステータス確認
echo "📊 アプリケーションのステータス:"
flyctl status

echo "✅ アプリケーションが停止しました"
echo "💰 課金が停止されました（マシン数: 0）"
echo "🚀 再起動するには: ./start.sh または flyctl scale count 1"