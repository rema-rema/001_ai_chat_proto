# マルチステージビルド：Next.js + Flask 同梱
FROM node:18-alpine AS frontend-build

# フロントエンド作業ディレクトリ
WORKDIR /app/client

# package.jsonとpackage-lock.jsonをコピー
COPY client/package*.json ./

# 依存関係をインストール
RUN npm install

# Next.jsアプリケーションのソースコードをコピー
COPY client/ ./

# Next.jsアプリケーションをビルド（静的エクスポート）
RUN npm run build

# Python環境でFlaskアプリケーションを実行
FROM python:3.11-slim

# 作業ディレクトリを設定
WORKDIR /app

# システムの依存関係をインストール
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Pythonの依存関係をコピーしてインストール
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Flaskアプリケーションをコピー
COPY backend/ ./

# フロントエンドのビルド結果をコピー
COPY --from=frontend-build /app/client/out ./client/out

# ポートを公開
EXPOSE 8080

# アプリケーションを起動
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "app:app"]