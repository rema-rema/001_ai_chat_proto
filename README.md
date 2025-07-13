# AI Chat App Prototype

A simple web application that provides a chat interface using the OpenAI API (GPT-4). This project consists of a Next.js frontend and a Python Flask backend, designed for deployment on Fly.io.

## 🏗️ Project Structure

```
001_ai_chat_proto/
├── client/          # Next.js frontend application
│   ├── src/
│   │   ├── app/     # Next.js app directory
│   │   └── components/
│   ├── package.json
│   ├── tsconfig.json
│   └── next.config.js
├── backend/         # Python Flask backend
│   ├── app.py       # Main Flask application
│   └── requirements.txt
├── start.bat        # 自動起動スクリプト
├── check.bat        # 起動確認スクリプト
├── stop.bat         # サーバー停止スクリプト
├── Dockerfile       # Multi-stage Docker build
├── fly.toml         # Fly.io deployment configuration
├── .env.example     # Environment variables template
└── design.md        # Project design document
```

## 🚀 Features

- **Real-time Chat Interface**: Clean, responsive chat UI built with Next.js and TypeScript
- **OpenAI Integration**: Powered by GPT-4 for intelligent conversations
- **Message History**: Maintains conversation context during chat sessions
- **Error Handling**: Robust error handling for API failures and network issues
- **Loading States**: Visual feedback during message processing
- **Production Ready**: Configured for deployment on Fly.io with Docker

## 🛠️ Setup Instructions

### Prerequisites

- Node.js 18+ (for frontend development)
- Python 3.11+ (for backend development)
- OpenAI API key
- Docker (for deployment)
- Fly.io CLI (for deployment)

## ⚡ Quick Start (推奨)

### 🎯 **最も簡単な起動方法**

1. **環境変数設定** (.envファイル作成)
   ```bash
   cp .env.example .env
   # .envファイルを編集してOPENAI_API_KEYを設定
   ```

2. **自動起動**
   ```bash
   # プロジェクトルートで実行
   start.bat
   ```
   
3. **ブラウザでアクセス**
   ```
   http://localhost:3000 または http://localhost:3001
   ```

### 🔍 **起動確認・トラブルシューティング**

```bash
# 起動状況確認
check.bat

# サーバー停止
stop.bat
```

## 📋 Manual Setup (手動セットアップ)

### 🔧 環境変数設定

```bash
cd 001_ai_chat_proto
cp .env.example .env
```
**.env ファイルを編集して以下を設定：**
```
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
PORT=5000
FLASK_ENV=development
```

### 🚀 手動起動手順

**方法1: 別々のターミナルで起動**

**ターミナル1 (バックエンド):**
```bash
cd backend
pip install -r requirements.txt
py app.py
```
→ Backend: `http://localhost:5000`

**ターミナル2 (フロントエンド):**
```bash
cd client
npm install
npm run dev
```
→ Frontend: `http://localhost:3000`

**方法2: バックグラウンドで起動**
```bash
# バックエンド (バックグラウンド)
cd backend && start /min cmd /c "py app.py"

# フロントエンド (バックグラウンド)
cd client && start /min cmd /c "npm run dev"
```

### 🧪 動作確認手順

**1. API疎通テスト**
```bash
# ヘルスチェック
curl http://localhost:5000

# チャットAPI テスト
curl -X POST http://localhost:5000/api/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"message\": \"Hello\", \"history\": []}"
```

**2. フロントエンド確認**
1. ブラウザで `http://localhost:3000` にアクセス
2. "Hello" と入力して送信
3. AI応答が表示されることを確認

**3. 統合テスト**
- メッセージ送信 → ローディング → AI応答の流れを確認
- 複数回やり取りして会話履歴が維持されることを確認

### Production Deployment (Fly.io)

1. **Install Fly.io CLI and authenticate**
   ```bash
   curl -L https://fly.io/install.sh | sh
   fly auth login
   ```

2. **Set up your Fly.io app**
   ```bash
   fly apps create ai-chat-proto
   ```

3. **Set environment variables**
   ```bash
   fly secrets set OPENAI_API_KEY=your_actual_api_key_here
   ```

4. **Deploy**
   ```bash
   fly deploy
   ```

## 🔧 Configuration

### Environment Variables

- `OPENAI_API_KEY`: Your OpenAI API key (required)
- `PORT`: Backend server port (default: 5000)
- `FLASK_ENV`: Flask environment (development/production)

### API Endpoints

- `GET /`: Health check endpoint
- `POST /api/chat`: Chat endpoint for sending messages

## 🔧 Troubleshooting (トラブルシューティング)

### 🚨 よくある問題と解決方法

#### **1. バックエンドが起動しない**

**症状:** `py app.py` でエラーが発生する

**原因と対処法:**
```bash
# 1. 依存関係の問題
pip install -r requirements.txt

# 2. OpenAI APIキーの問題
# .envファイルでOPENAI_API_KEYを確認

# 3. ポートの競合
# 他のアプリがポート5000を使用している
netstat -an | findstr 5000
```

**確認コマンド:**
```bash
cd backend
py -c "import flask, openai; print('OK')"
```

#### **2. フロントエンドが起動しない**

**症状:** `npm run dev` でエラーが発生する

**原因と対処法:**
```bash
# 1. Node.js依存関係の問題
cd client
npm install

# 2. ポートの競合 (3000番ポート)
# 自動的に3001ポートに変更される

# 3. Next.jsキャッシュの問題
npm run clean
rm -rf .next
npm run dev
```

#### **3. API疎通に失敗する**

**症状:** チャットでメッセージを送信してもエラーが返る

**原因と対処法:**
```bash
# 1. OpenAI APIキーの確認
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "test", "history": []}'

# 2. APIキーの有効性確認
# OpenAIダッシュボードでAPIキーと使用量を確認

# 3. ネットワーク接続確認
ping api.openai.com
```

#### **4. プロセスが残り続ける問題**

**症状:** サーバーが停止できない

**対処法:**
```bash
# 自動停止スクリプト使用
stop.bat

# 手動でプロセス停止
tasklist | findstr python
tasklist | findstr node
taskkill /f /im python.exe
taskkill /f /im node.exe
```

### 📋 各環境での詳細動作

#### **バックエンド起動時の内部処理**
1. `.env`ファイルから環境変数読み込み
2. OpenAI APIクライアント初期化
3. Flask-CORSでクロスオリジン設定
4. `0.0.0.0:5000`でサーバー起動
5. デバッグモード有効化

#### **フロントエンド起動時の内部処理**
1. Next.js開発サーバー起動
2. TypeScriptコンパイル
3. `localhost:3000`でサーバー起動（競合時は3001）
4. HMR（Hot Module Replacement）有効化
5. プロキシ設定でバックエンドAPI連携

#### **API疎通時の内部処理**
1. フロントエンド → `/api/chat` POST リクエスト
2. Next.js プロキシ → `localhost:5000/api/chat`
3. Flask サーバーでリクエスト処理
4. OpenAI API呼び出し
5. レスポンス返却 → フロントエンド表示

### 🛠️ エラーログの確認方法

**バックエンドログ:**
- コマンドプロンプトにFlaskのログが表示
- `500 Internal Server Error` の場合はデバッガーページ確認

**フロントエンドログ:**
- ブラウザの開発者ツール (F12) → Console タブ
- ネットワークタブでAPI呼び出し状況確認

**APIエラー確認:**
```bash
# 詳細エラー情報取得
curl -v -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "test", "history": []}'
```

## 🧪 Development Notes

- フロントエンドは開発時にバックエンドAPIへのプロキシを設定済み
- バックエンドはFlask-CORSでクロスオリジンリクエストに対応
- OpenAI API呼び出しは効率化のため直近10件のメッセージのみ送信
- アプリケーションはデフォルトでGPT-4モデルを使用（`backend/app.py`で変更可能）

## 📝 Future Enhancements

- [ ] Database integration for persistent chat history (Supabase planned)
- [ ] User authentication system
- [ ] Vector search for conversation consistency
- [ ] Payment integration with Stripe
- [ ] Message export functionality
- [ ] Multi-language support

## 🔒 Security Considerations

- API keys are stored securely using environment variables
- CORS is properly configured for production
- Input validation is implemented for all API endpoints
- Rate limiting considerations for OpenAI API usage

## 📄 License

This project is for development and testing purposes. Please ensure compliance with OpenAI's usage policies when deploying to production.

## 🤝 Contributing

This project was developed using AI-driven development with Claude Code. For consistency and maintenance, please follow the existing code patterns and architecture.

---

**Note**: This is a prototype application. For production use, consider implementing additional security measures, monitoring, and scalability optimizations.