from flask import Flask, request, jsonify, send_from_directory, send_file
from flask_cors import CORS
from openai import OpenAI
import os
from dotenv import load_dotenv
from functools import wraps

# 本番環境では client/out、ローカルでは ../client/out
is_production = os.getenv('FLY_APP_NAME') is not None
static_folder = 'client/out' if is_production else '../client/out'
app = Flask(__name__, static_folder=static_folder, static_url_path='')
CORS(app)

# Windows環境変数を優先してAPIキーを取得
api_key = os.getenv('OPENAI_API_KEY')
if not api_key:
    load_dotenv()
    load_dotenv('../.env.local')
    api_key = os.getenv('OPENAI_API_KEY')

client = OpenAI(api_key=api_key)

# アクセストークン認証デコレータ
def require_access_token(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        access_token = os.getenv('ACCESS_TOKEN')
        if access_token:
            provided_token = request.headers.get('Authorization')
            if not provided_token or provided_token != f'Bearer {access_token}':
                return jsonify({"error": "Unauthorized"}), 401
        return f(*args, **kwargs)
    return decorated_function

@app.route('/health', methods=['GET'])
def health_check():
    """ヘルスチェック用エンドポイント"""
    return jsonify({"status": "healthy", "service": "AI Chat Backend"})

@app.route('/api/chat', methods=['POST'])
@require_access_token
def chat():
    """メッセージを処理してAI応答を返すチャットエンドポイント"""
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({"error": "Message is required"}), 400
        
        user_message = data['message']
        chat_history = data.get('history', [])
        
        if not client.api_key:
            return jsonify({"error": "OpenAI API key not configured"}), 500
        
        messages = []
        
        # システムメッセージを追加
        messages.append({
            "role": "system",
            "content": "あなたは親切なAIアシスタントです。明確で簡潔で役立つ回答を提供してください。"
        })
        
        # 過去10件の会話履歴を追加
        for msg in chat_history[-10:]:
            messages.append({
                "role": msg['role'],
                "content": msg['content']
            })
        
        # ユーザーメッセージを追加
        messages.append({
            "role": "user",
            "content": user_message
        })
        
        response = client.chat.completions.create(
            model="gpt-4",
            messages=messages,
            max_tokens=1000,
            temperature=0.7
        )
        
        ai_response = response.choices[0].message.content
        
        return jsonify({
            "response": ai_response,
            "status": "success"
        })
        
    except Exception as e:
        if "authentication" in str(e).lower():
            return jsonify({"error": "Invalid OpenAI API key"}), 401
        elif "rate_limit" in str(e).lower():
            return jsonify({"error": "OpenAI API rate limit exceeded"}), 429
        elif "openai" in str(e).lower():
            return jsonify({"error": f"OpenAI API error: {str(e)}"}), 500
        else:
            return jsonify({"error": f"Internal server error: {str(e)}"}), 500

@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Endpoint not found"}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Internal server error"}), 500

@app.route('/')
def serve_index():
    """Next.js静的ファイルのindex.htmlを配信"""
    return send_file(os.path.join(app.static_folder, 'index.html'))

@app.route('/<path:path>')
def serve_static(path):
    """Next.js静的ファイルを配信"""
    try:
        return send_from_directory(app.static_folder, path)
    except:
        # SPA対応：存在しないパスは全てindex.htmlにリダイレクト
        return send_file(os.path.join(app.static_folder, 'index.html'))

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)