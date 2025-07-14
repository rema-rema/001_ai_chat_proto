# Fly.io デプロイ手順書（既存アプリの調整版）

## 📋 概要

このドキュメントは、**すでにローカルで動作している既存のOpenAI APIチャットアプリ**をFly.ioにデプロイするための手順書です。Claude Codeには既存のファイル構成を尊重してもらい、デプロイに必要な追加ファイルのみを作成してもらいます。

---

## 🎯 前提条件

- ✅ **既存のチャットアプリがローカルで動作中**（Claude Codeが以前作成）
- ✅ OpenAI APIキー取得済（`.env`で管理）
- ✅ GitHubアカウント＆リポジトリ作成済
- ✅ Fly.ioアカウント登録済
- ✅ Windowsローカル環境

---

## 🤖 パート1: Claude Codeへの依頼内容

### Claude Codeへの指示文:

```
【重要】既存のローカルアプリをそのまま活かしてFly.ioにデプロイしたいです。

現在のフォルダ構成とファイルはすべてそのまま使用してください。
新規作成や大幅な変更は避け、既存の構成を尊重した上で、Fly.ioデプロイに必要な最小限のファイルのみを追加してください。

まず、現在のフォルダ構成を確認させてください：
- app.py（またはmain.pyなど）の内容
- templatesフォルダの中身
- staticフォルダの有無と中身
- requirements.txtの有無と内容
- その他の既存ファイル

確認後、以下のデプロイ用ファイルを追加で作成してください：

【必須で追加が必要なファイル】
1. Dockerfile（既存アプリの構成に合わせて作成）
2. fly.toml（Fly.io設定ファイル）
3. .env.example（環境変数のテンプレート）※.envが既にある場合
4. .gitignore（追加項目があれば）

【必要に応じて追加するファイル（私の提案）】
5. start.sh / stop.sh（Windowsでも使えるデプロイ補助スクリプト）
6. requirements.txtの更新（gunicornなど本番用パッケージの追加のみ）

【セキュリティ対策の提案】
現在認証機能がないため、以下のいずれかを提案します：
- 案1: 既存のapp.pyに最小限のBasic認証を追加（数行の追加で済む）
- 案2: IPアドレス制限（Fly.ioの機能を使用）
- 案3: 環境変数でアクセストークンをチェック

どの方法が既存のコードに最も影響が少ないか判断して実装してください。

【注意点】
- 既存のコードはできる限り変更しない
- ポート番号は環境変数PORTを使用（デフォルト8080）
- 既存の.envファイルの構造を維持
```

### 📁 参考：一般的なFlaskアプリの構成（あくまで参考）

```
your-chat-app/
├── app.py（またはmain.py）     # メインのFlaskアプリ
├── templates/                  # HTMLテンプレート
│   └── index.html             
├── static/                     # CSS/JSファイル（ある場合）
├── requirements.txt            # 依存パッケージ
├── .env                        # 環境変数（既存）
├── 【追加】Dockerfile          # Claude Codeが作成
├── 【追加】fly.toml           # Claude Codeが作成
├── 【追加】.env.example       # Claude Codeが作成
├── 【追加】.gitignore         # Claude Codeが作成/更新
├── 【追加】start.sh           # Claude Codeが提案
└── 【追加】stop.sh            # Claude Codeが提案
```

---

## 👤 パート2: 手動で実行する作業

### 1. **Fly.io CLIのインストール**（15分）

1. [Fly.io公式サイト](https://fly.io/docs/hands-on/install-flyctl/)にアクセス
2. Windows用インストーラーをダウンロード
3. PowerShellを管理者権限で開いて実行：
   ```powershell
   iwr https://fly.io/install.ps1 -useb | iex
   ```
4. インストール確認：
   ```bash
   flyctl version
   ```

### 2. **Fly.ioへのログイン**（5分）

```bash
flyctl auth login
```
- ブラウザが開くので、Fly.ioアカウントでログイン

### 3. **環境変数の設定**（5分）

1. 既存の`.env`ファイルを確認
2. Claude Codeが提案した追加の環境変数があれば追記
3. `.env`が`.gitignore`に含まれていることを確認

### 4. **初回デプロイ**（10分）

1. プロジェクトディレクトリで実行：
   ```bash
   flyctl launch
   ```
   - アプリ名を入力（例：my-ai-chat-app-20250714）
   - リージョン選択（Tokyo = nrt を推奨）
   - PostgreSQLは「No」を選択
   - Redisは「No」を選択
   - デプロイは「No」を選択（後で実行）

2. シークレット（環境変数）の設定：
   ```bash
   # 既存の.envファイルから必要な値を設定
   flyctl secrets set OPENAI_API_KEY="your-actual-api-key"
   
   # Claude Codeが追加した認証用の環境変数があれば設定
   # 例：flyctl secrets set BASIC_AUTH_PASSWORD="your-password"
   ```

3. デプロイ実行：
   ```bash
   flyctl deploy
   ```

### 5. **動作確認**（5分）

1. アプリを開く：
   ```bash
   flyctl open
   ```

2. ログ確認：
   ```bash
   flyctl logs
   ```

3. 認証が設定されている場合はログイン

### 6. **日常的な運用**

#### アプリの起動（コスト削減のため停止していた場合）：
```bash
./start.sh
# または
flyctl scale count 1
```

#### アプリの停止（使用しない時）：
```bash
./stop.sh
# または
flyctl scale count 0
```

#### コード更新後の再デプロイ：
```bash
flyctl deploy
```

---

## ⚠️ 注意事項

1. **既存アプリの保護**
   - デプロイ前に必ずローカルでバックアップを取る
   - Gitでコミットしてから作業を開始

2. **無料枠の制限**
   - 月間のリソース制限があるため、使用しない時は停止推奨
   - `flyctl scale count 0`で課金を回避

3. **環境変数の管理**
   - 新しく追加された環境変数のみFly.ioに設定
   - 既存の.env構造は変更しない

4. **段階的な確認**
   - まずローカルで変更内容をテスト
   - 問題なければFly.ioにデプロイ

---

## 🚀 実行順序のまとめ

1. **現在のプロジェクトをバックアップ**
2. **Claude Codeに上記パート1の内容を依頼**
3. **Claude Codeが提案した追加ファイルを確認**
4. **ローカルで動作確認**
5. **Fly.io CLIをインストール**
6. **手動作業（パート2）を順番に実行**

---

## 📞 トラブルシューティング

### 既存アプリが動かなくなった場合：
- バックアップから復元
- 追加したファイルのみを削除して再確認

### デプロイが失敗する場合：
```bash
flyctl logs
flyctl doctor
```

### ポートエラーの場合：
- 既存アプリのポート設定を確認
- 環境変数PORTが正しく読み込まれているか確認

---

## 🎯 重要な原則

**既存のアプリケーションを壊さない**ことが最優先です。Claude Codeには既存の構成を尊重してもらい、必要最小限の追加のみを行ってもらいましょう。