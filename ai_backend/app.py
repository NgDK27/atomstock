# from flask import Flask, request, jsonify
# import requests
# from langfuse.decorators import observe
# from dotenv import load_dotenv
# import os
# from flask_cors import CORS

# app = Flask(__name__)
# CORS(app)  # Allow all origins

# # Load environment variables from .env file
# load_dotenv()

# # Get the API key from environment variables
# OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# # If the API key is not found, ask the user to input it
# if not OPENAI_API_KEY:
#     print("No API key found in environment variables.")
#     OPENAI_API_KEY = input("Please enter your OPENAI_API_KEY: ")
    
# @observe()  # Track with Langfuse
# def call_openai(prompt, user_id, model='gpt-4o-mini', max_tokens=150):
#     """Calls OpenAI API and tracks prompt usage with Langfuse."""
#     response = requests.post(
#         'https://api.openai.com/v1/chat/completions',
#         headers={
#             'Authorization': f'Bearer {OPENAI_API_KEY}',
#             'Content-Type': 'application/json'
#         },
#         json={
#             'model': model,
#             'messages': [
#                 {'role': 'system', 'content': 'You are a helpful assistant.'},
#                 {'role': 'user', 'content': prompt},
#             ],
#             'max_tokens': max_tokens
#         }
#     )

#     if response.status_code == 200:
#         response_data = response.json()
#         result = response_data.get('choices', [{}])[0].get('message', {}).get('content', 'No content').strip()
#         return result
#     else:
#         return {'error': 'Failed to generate response', 'status_code': response.status_code}


# @app.route('/generate_response', methods=['POST'])
# def generate_response():
#     data = request.get_json()
#     prompt = data.get('prompt')
#     user_id = data.get('user_id')

#     # Call OpenAI with Langfuse tracking
#     response = call_openai(prompt, user_id)

#     if isinstance(response, dict) and 'error' in response:
#         return jsonify(response), response['status_code']
#     else:
#         return jsonify({'response': response}), 200


# if __name__ == '__main__':
#     # app.run(debug=True)
#     app.run(host='0.0.0.0', port=5000, debug=True)

"""
=========================
    TESTING PURPOSE
=========================
curl -X POST http://127.0.0.1:5000/generate_response -H "Content-Type: application/json" -d '{"prompt": "Hello, how are you?", "user_id": "123"}'
"""


"""
LANGFUSE + OPENAI
"""
# from flask import Flask, request, jsonify
# from langfuse.decorators import observe
# from langfuse.openai import openai  # Import Langfuse OpenAI integration
# from dotenv import load_dotenv
# import os
# from flask_cors import CORS

# app = Flask(__name__)
# CORS(app)  # Allow all origins

# # Load environment variables from .env file
# load_dotenv()

# # Get the API key from environment variables
# OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# # If the API key is not found, ask the user to input it
# if not OPENAI_API_KEY:
#     print("No API key found in environment variables.")
#     OPENAI_API_KEY = input("Please enter your OPENAI_API_KEY: ")

# # Configure OpenAI with the API key for Langfuse integration
# openai.api_key = OPENAI_API_KEY

# @observe()  # Track with Langfuse
# def call_openai(prompt, user_id, model='gpt-4o-mini', max_tokens=150):
#     """Calls OpenAI API and tracks prompt usage with Langfuse."""
#     response = openai.chat.completions.create(
#         model=model,
#         max_tokens=max_t1okens,
#         messages=[
#             {'role': 'system', 'content': 'You are a helpful assistant.'},
#             {'role': 'user', 'content': prompt},
#         ]
#     )

#     if response.choices:
#         result = response.choices[0].message.content.strip()
#         return result
#     else:
#         return {'error': 'Failed to generate response'}

# @app.route('/generate_response', methods=['POST'])
# def generate_response():
#     data = request.get_json()
#     prompt = data.get('prompt')
#     user_id = data.get('user_id')

#     # Call OpenAI with Langfuse tracking
#     response = call_openai(prompt, user_id)

#     if isinstance(response, dict) and 'error' in response:
#         return jsonify(response), 500  # Internal Server Error
#     else:
#         return jsonify({'response': response}), 200

# if __name__ == '__main__':
#     app.run(debug=True)


from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
from services.openai_service import openai_bp
from services.conversation_service import conversation_bp

app = Flask(__name__)
CORS(app)  # Allow all origins

# Load environment variables
load_dotenv()

# Register Blueprints
app.register_blueprint(openai_bp, url_prefix='/api')
app.register_blueprint(conversation_bp, url_prefix='/api')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
