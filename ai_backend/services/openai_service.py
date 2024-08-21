from flask import Blueprint, request, jsonify
import requests
from config import config
from langfuse.decorators import observe, langfuse_context
from dotenv import load_dotenv

openai_bp = Blueprint('openai_bp', __name__)

load_dotenv()

@observe()  # Track with Langfuse
def call_openai(prompt, user_id, model='gpt-4o-mini', max_tokens=150):
    """Calls OpenAI API and tracks prompt usage with Langfuse."""
    response = requests.post(
        'https://api.openai.com/v1/chat/completions',
        headers={
            'Authorization': f'Bearer {config.OPENAI_API_KEY}',
            'Content-Type': 'application/json'
        },
        json={
            'model': model,
            'messages': [
                {'role': 'system', 'content': 'You are a helpful assistant.'},
                {'role': 'user', 'content': prompt},
            ],
            'max_tokens': max_tokens
        }
    )

    if response.status_code == 200:
        response_data = response.json()
        result = response_data.get('choices', [{}])[0].get('message', {}).get('content', 'No content').strip()
        langfuse_context.update_current_trace(
            user_id=user_id
        )
        return result
    else:
        return {'error': 'Failed to generate response', 'status_code': response.status_code}

@openai_bp.route('/generate_response', methods=['POST'])
def generate_response():
    data = request.get_json()
    prompt = data.get('prompt')
    user_id = data.get('user_id')

    # Call OpenAI with Langfuse tracking
    response = call_openai(prompt, user_id)

    if isinstance(response, dict) and 'error' in response:
        return jsonify(response), response['status_code']
    else:
        return jsonify({'response': response}), 200
