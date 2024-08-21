# from flask import Flask, request, jsonify
# import requests

# app = Flask(__name__)

# # Your OpenAI API key
# OPENAI_API_KEY = ''
# @app.route('/generate_response', methods=['POST'])
# def generate_response():
#     data = request.get_json()
#     prompt = data.get('prompt')
#     user_id = data.get('user_id')

#     # Call OpenAI API
#     response = requests.post(
#         'https://api.openai.com/v1/chat/completions',
#         headers={
#             'Authorization': f'Bearer {OPENAI_API_KEY}',
#             'Content-Type': 'application/json'
#         },
#         json={
#             'model': 'gpt-3.5-turbo',
#             'messages': [
#                 {'role': 'system', 'content': 'You are a helpful assistant.'},
#                 {'role': 'user', 'content': prompt},
#             ],
#             'max_tokens': 150
#         }
#     )

#     if response.status_code == 200:
#         response_data = response.json()
#         result = response_data.get('choices', [{}])[0].get('message', {}).get('content', 'No content').strip()
#         return jsonify({'response': result}), 200
#     else:
#         return jsonify({'error': 'Failed to generate response', 'status_code': response.status_code}), response.status_code

# if __name__ == '__main__':
#     app.run(debug=True)


from flask import Flask, request, jsonify
from dotenv import load_dotenv
import os
from flask_cors import CORS
from langfuse.callback import CallbackHandler
import chain
app = Flask(__name__)
CORS(app)  # Allow all origins

# Load environment variables from .env file
load_dotenv()
LANGFUSE_PUBLIC_KEY =os.getenv("LANGFUSE_PUBLIC_KEY")
LANGFUSE_SECRET_KEY =os.getenv("LANGFUSE_SECRET_KEY")

langfuse_handler = CallbackHandler(
    secret_key=LANGFUSE_SECRET_KEY,
    public_key=LANGFUSE_PUBLIC_KEY,
    host="https://cloud.langfuse.com", # 🇪🇺 EU region
    # host="https://us.cloud.langfuse.com", # 🇺🇸 US region
)
# Get the API key from environment variables
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# # If the API key is not found, ask the user to input it
# if not OPENAI_API_KEY:
#     print("No API key found in environment variables.")
#     OPENAI_API_KEY = input("Please enter your OPENAI_API_KEY: ")
#
#
# def call_openai(prompt, user_id, model='gpt-3.5-turbo', max_tokens=150):
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
#
#     if response.status_code == 200:
#         response_data = response.json()
#         result = response_data.get('choices', [{}])[0].get('message', {}).get('content', 'No content').strip()
#         return result
#     else:
#         return {'error': 'Failed to generate response', 'status_code': response.status_code}


@app.route('/generate_response', methods=['POST'])
def generate_response():
    data = request.get_json()
    prompt = data.get('prompt')
    user_id = data.get('user_id')

    # Call OpenAI with Langfuse tracking
    # response = call_openai(prompt, user_id)
    get_chain = chain.get_chain()
    response = get_chain.invoke({"input":prompt}, config={"callbacks": [langfuse_handler]})['answer']
    if isinstance(response, dict) and 'error' in response:
        return jsonify(response), response['status_code']
    else:
        return jsonify({'response': response}), 200


if __name__ == '__main__':
    app.run(debug=True)