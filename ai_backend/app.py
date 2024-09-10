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
@app.route('/generate_response', methods=['POST'])
def generate_response():
    data = request.get_json()
    prompt = data.get('prompt')
    # user_id = data.get('user_id')

    get_chain = chain.get_chain()
    response = get_chain.invoke({"input":prompt}, config={"callbacks": [langfuse_handler]})['answer']
    if isinstance(response, dict) and 'error' in response:
        return jsonify(response), response['status_code']
    else:
        return jsonify({'response': response}), 200


if __name__ == '__main__':
     app.run(host='192.168.25.122', port=5000, debug=True)