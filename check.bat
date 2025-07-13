@echo off
echo ====================================
echo AI チャットアプリ状況確認
echo ====================================
echo.

:: バックエンドの確認
echo [確認中] バックエンドサーバー状況...
curl -s http://localhost:5000 >nul 2>&1
if errorlevel 1 (
    echo [×] バックエンドサーバーが起動していません (http://localhost:5000)
    set backend_status=停止
) else (
    echo [○] バックエンドサーバーが正常に動作しています
    set backend_status=稼働中
)

echo.

:: フロントエンドの確認
echo [確認中] フロントエンドサーバー状況...
curl -s http://localhost:3000 >nul 2>&1
if errorlevel 1 (
    curl -s http://localhost:3001 >nul 2>&1
    if errorlevel 1 (
        echo [×] フロントエンドサーバーが起動していません
        set frontend_status=停止
        set frontend_url=未起動
    ) else (
        echo [○] フロントエンドサーバーが動作しています (ポート3001)
        set frontend_status=稼働中
        set frontend_url=http://localhost:3001
    )
) else (
    echo [○] フロントエンドサーバーが動作しています (ポート3000)
    set frontend_status=稼働中
    set frontend_url=http://localhost:3000
)

echo.

:: API疎通テスト
echo [確認中] API疎通テスト...
curl -s -X POST http://localhost:5000/api/chat -H "Content-Type: application/json" -d "{\"message\": \"test\", \"history\": []}" >nul 2>&1
if errorlevel 1 (
    echo [×] API疎通テストに失敗しました
    set api_status=失敗
) else (
    echo [○] API疎通テストが成功しました
    set api_status=正常
)

echo.
echo ====================================
echo 状況まとめ
echo ====================================
echo バックエンド:   %backend_status%
echo フロントエンド: %frontend_status%
echo API疎通:       %api_status%
if defined frontend_url (
    if not "%frontend_url%"=="未起動" (
        echo.
        echo アクセスURL: %frontend_url%
    )
)
echo ====================================
echo.

:: 問題がある場合の対処法表示
if "%backend_status%"=="停止" (
    echo [対処法] バックエンドが停止しています
    echo 1. backend\app.py でエラーが発生していないか確認
    echo 2. .envファイルにOPENAI_API_KEYが正しく設定されているか確認
    echo 3. 手動でbackendディレクトリでpy app.pyを実行して確認
    echo.
)

if "%frontend_status%"=="停止" (
    echo [対処法] フロントエンドが停止しています
    echo 1. clientディレクトリでnpm installが完了しているか確認
    echo 2. 手動でclientディレクトリでnpm run devを実行して確認
    echo.
)

if "%api_status%"=="失敗" (
    echo [対処法] API疎通に失敗しています
    echo 1. OpenAI APIキーが有効か確認
    echo 2. インターネット接続を確認
    echo 3. OpenAIサービスの状況を確認
    echo.
)

pause