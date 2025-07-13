from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

@app.route('/', methods=['GET'])
def health_check():
    """ヘルスチェック用エンドポイント"""
    return jsonify({"status": "healthy", "service": "AI Chat Backend"})

@app.route('/api/chat', methods=['POST'])
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

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)