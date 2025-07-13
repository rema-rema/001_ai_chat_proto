@echo off
echo ====================================
echo AI チャットアプリ停止スクリプト
echo ====================================
echo.

echo [実行中] サーバープロセスを停止しています...

:: Pythonプロセス（バックエンド）を停止
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im py.exe >nul 2>&1

:: Node.jsプロセス（フロントエンド）を停止
taskkill /f /im node.exe >nul 2>&1

:: コマンドプロンプトウィンドウを閉じる
taskkill /f /fi "WindowTitle eq AIチャットバックエンド*" >nul 2>&1
taskkill /f /fi "WindowTitle eq AIチャットフロントエンド*" >nul 2>&1

echo [完了] すべてのサーバーを停止しました
echo.
pause