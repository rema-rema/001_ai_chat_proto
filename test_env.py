import os
from dotenv import load_dotenv

print("=== Environment Variable Test ===")

# 現在の環境変数をチェック
print(f"System OPENAI_API_KEY: {'SET' if os.getenv('OPENAI_API_KEY') else 'NOT SET'}")

# .envファイルを読み込み
load_dotenv('.env')
print(f"After loading .env: {'SET' if os.getenv('OPENAI_API_KEY') else 'NOT SET'}")

# .env.localファイルを読み込み
load_dotenv('.env.local')
api_key = os.getenv('OPENAI_API_KEY')
print(f"After loading .env.local: {'SET' if api_key else 'NOT SET'}")

if api_key:
    # APIキーの値をチェック（最初の10文字のみ表示）
    print(f"API Key preview: {api_key[:10]}...")
    print(f"API Key contains %: {'%' in api_key}")
else:
    print("API Key is None or empty")

print("=== End Test ===")