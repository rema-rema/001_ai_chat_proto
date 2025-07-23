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
├── deploy.ps1       # Fly.io deployment script
├── start.ps1        # Fly.io start script
├── stop.ps1         # Fly.io stop script
├── status.ps1       # Fly.io status check script
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
- **Access Token Security**: Protected API access with authentication
- **Production Ready**: Configured for deployment on Fly.io with Docker

## 🌐 Stage Environment (検証環境)

### 🚀 起動方法

```powershell
# プロジェクトディレクトリに移動
cd C:\Users\rema\project\001_ai_chat_proto

# アプリケーション起動
flyctl scale count 1

# 起動確認
flyctl status
```

### 🔗 アクセス方法

**検証環境URL:**
```
https://ai-chat-proto.fly.dev/?token=001-xac0ets-s1sFa-xtte4
```

**重要:** URLに `?token=001-xac0ets-s1sFa-xtte4` パラメータが必要です。これはセキュリティ機能で、OpenAI API の不正使用を防ぎます。

### 📊 状況確認

```powershell
# アプリケーション状態確認
flyctl status

# ログ確認
flyctl logs

# PowerShellスクリプトで確認
.\status.ps1

# リアルタイムログ監視（問題発生時）
.\status.ps1 -Logs
```

### ⏹️ 停止方法

```powershell
# アプリケーション停止
flyctl scale count 0

# PowerShellスクリプトで停止
.\stop.ps1

# 停止確認
flyctl status
```

### 🛠️ 管理用スクリプト

- `.\start.ps1` - アプリケーション起動 + ログ監視
- `.\stop.ps1` - アプリケーション停止 + 課金確認
- `.\status.ps1` - 状況確認
- `.\deploy.ps1` - 新しいバージョンのデプロイ

## 🛠️ Local Development (ローカル開発)

### Prerequisites

- Node.js 18+ (for frontend development)
- Python 3.11+ (for backend development)
- OpenAI API key

### 🔧 環境変数設定

```cmd
cd 001_ai_chat_proto
copy .env.example .env
```

**.env ファイルを編集して以下を設定：**
```
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ACCESS_TOKEN=your-local-access-token
PORT=5000
FLASK_ENV=development
```

### 🚀 ローカル起動手順

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

### 🧪 ローカル動作確認

1. ブラウザで `http://localhost:3000?token=your-local-access-token` にアクセス
2. "Hello" と入力して送信
3. AI応答が表示されることを確認

## 🔧 Configuration

### Environment Variables

- `OPENAI_API_KEY`: Your OpenAI API key (required)
- `ACCESS_TOKEN`: Access token for API authentication (required)
- `PORT`: Backend server port (default: 5000)
- `FLASK_ENV`: Flask environment (development/production)
- `FLY_APP_NAME`: Automatically set by Fly.io (production detection)

### API Endpoints

- `GET /health`: Health check endpoint
- `POST /api/chat`: Chat endpoint for sending messages (requires Authorization header)
- `GET /`: Serves the Next.js static frontend

## 🔒 Security Features

- **Access Token Authentication**: All chat API calls require valid Bearer token
- **Environment Variable Protection**: API keys stored securely, never in source code
- **CORS Configuration**: Properly configured for frontend-backend communication
- **Input Validation**: Implemented for all API endpoints

## 🌍 Deployment Architecture

### Branch Strategy
- `main` - Production ready code
- `develop` - Development branch
- `stage` - Staging environment (currently deployed to Fly.io)

### Production Environment
- **Platform**: Fly.io
- **Runtime**: Multi-stage Docker build (Next.js static + Flask)
- **Region**: Tokyo (nrt)
- **Auto-scaling**: Enabled with min 0, auto-start on request

## 📝 Future Enhancements

- [ ] Daily usage limits per access token
- [ ] User management system
- [ ] Database integration for persistent chat history
- [ ] Message export functionality
- [ ] Multi-language support

## 🔧 Troubleshooting

### Common Issues

1. **401 Unauthorized Error**
   - Ensure URL includes `?token=` parameter
   - Check token matches the one set in environment variables

2. **App Not Responding**
   - Check if machines are running: `flyctl status`
   - Restart if needed: `flyctl scale count 0` then `flyctl scale count 1`

3. **API Errors**
   - Check logs: `flyctl logs`
   - Verify OpenAI API key is valid
   - Check environment variables: `flyctl secrets list`

## 📄 License

This project is for development and testing purposes. Please ensure compliance with OpenAI's usage policies when deploying to production.

---

**Note**: This is a prototype application. The stage environment is used for testing and validation before production deployment.