@echo off
echo ====================================
echo AI チャットアプリ起動スクリプト
echo ====================================
echo.

:: 環境変数ファイルの確認
if not exist ".env" (
    echo [エラー] .envファイルが見つかりません
    echo .env.exampleをコピーして.envファイルを作成し、OpenAI APIキーを設定してください
    pause
    exit /b 1
)

echo [情報] 環境変数ファイル確認 - OK
echo.

:: バックエンドの依存関係確認とインストール
echo [開始] バックエンドの依存関係インストール...
cd backend
pip install -r requirements.txt >nul 2>&1
if errorlevel 1 (
    echo [エラー] バックエンドの依存関係インストールに失敗しました
    pause
    exit /b 1
)
echo [完了] バックエンドの依存関係インストール完了
cd ..

:: フロントエンドの依存関係確認とインストール
echo [開始] フロントエンドの依存関係インストール...
cd client
npm install >nul 2>&1
if errorlevel 1 (
    echo [エラー] フロントエンドの依存関係インストールに失敗しました
    pause
    exit /b 1
)
echo [完了] フロントエンドの依存関係インストール完了
cd ..

echo.
echo ====================================
echo サーバー起動中...
echo ====================================

:: バックエンドサーバーをバックグラウンドで起動
echo [開始] バックエンドサーバー起動...
start "AIチャットバックエンド" /min cmd /c "cd backend && py app.py"

:: 3秒待機
timeout /t 3 /nobreak >nul

:: フロントエンドサーバーを起動
echo [開始] フロントエンドサーバー起動...
start "AIチャットフロントエンド" /min cmd /c "cd client && npm run dev"

:: 5秒待機
timeout /t 5 /nobreak >nul

echo.
echo ====================================
echo 起動完了！
echo ====================================
echo.
echo フロントエンド: http://localhost:3000
echo バックエンド:   http://localhost:5000
echo.
echo ブラウザでhttp://localhost:3000にアクセスしてください
echo.
echo サーバーを停止するには、開いたコマンドプロンプトでCtrl+Cを押してください
echo.
pause