# AI チャットアプリ開発計画 (Claude Code 用)

---

## ✅ 背景と目的

* **開発目的**:  
  OpenAI API (GPT-4o 以上) を使用して、幅広いユーザー向けのチャット機能を提供するWebアプリケーションを開発する。

* **開発アプローチ**:  
  Claude と Gemini CLI を使ったAI駆動開発を活用。人間の介入を最小限に抑え、AIにコード生成、改善、一貫性管理を任せる。

* **開発環境**:  
  GitHub Codespaces での開発、Fly.io へのデプロイ。ローカル環境は使用しない。

---

## ✅ 現在の準備状況

* GitHub リポジトリ: 作成済み  
* GitHub Codespaces: セットアップ完了・実行中 (Ubuntu ベース)  
* Fly.io: アカウント、請求、CLI インストール、認証完了  
* Claude Code: チャットアプリの UI コード生成に使用予定  

---

## ✅ 初期プロトタイプ

### 📌 シンプルなチャットインターフェース (プロトタイプ)

* **機能要件**:
  * 上部エリア: AI との会話履歴表示 (テキスト)
  * 下部エリア: テキスト入力フィールド + 送信ボタン
  * 送信後: OpenAI API からレスポンスを取得して表示
  * API キーは `.env` に `OPENAI_API_KEY` として保存

* **技術スタック**:
  * フロントエンド: Next.js with TypeScript
  * バックエンド: Python Flask with OpenAI API 統合
  * Fly.io デプロイ用の Dockerfile
  * Fly.io 設定用の `fly.toml`
  * セキュアなキー管理のための `.env.example` 含む

---

## ✅ 計画機能 (将来のプロトタイプ拡張)

1. チャット履歴の DB 保存 (Supabase 予定)
2. ユーザー認証 (延期)
3. 会話の一貫性維持 (例: MCPify.ai を使ったベクトル検索)
4. 支払い統合 (Stripe 経由で OpenAI API を有料化、別プロセス)

---

## ✅ Claude への指示

この設計書に基づいて以下のコードを生成してください:

* Next.js with TypeScript ベースのチャット UI
* OpenAI API と連携する Python Flask バックエンド (.env 統合)
* Fly.io デプロイ用の `Dockerfile` と `fly.toml`
* GitHub Codespaces 対応の開発者フレンドリーなフォルダ構成 (client/backend)
* 基本セットアップ手順を含む `README.md` ファイル

---

## ✅ 制約事項と注意点

* `.env` などの秘密鍵はコードに含めない
* Claude が MCPify.ai を知らなくても問題なし
* 開発は Linux (Codespaces) 環境を前提とし、Windows 固有のコードは避ける

---

## ✅ Claude への期待

* 全体アーキテクチャを意識したクリーンで拡張可能なコード生成
* Gemini CLI での将来の一貫性を容易にするためのコメントとセクション分け

