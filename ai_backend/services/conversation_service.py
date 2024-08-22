from flask import Blueprint, request, jsonify
import psycopg2
import uuid
from config import config

conversation_bp = Blueprint('conversation_bp', __name__)

def get_db_connection():
    """Creates and returns a connection to the PostgreSQL database."""
    return psycopg2.connect(
        host=config.DB_HOST,
        database=config.DB_NAME,
        user=config.DB_USER,
        password=config.DB_PASSWORD
    )

@conversation_bp.route('/conversations', methods=['POST'])
def create_conversation():
    data = request.get_json()
    user_id = data.get('user_id')
    message = data.get('message')

    conn = get_db_connection()
    cur = conn.cursor()

    conversation_id = str(uuid.uuid4())
    cur.execute(
        "INSERT INTO conversations (user_id, conversation_id, messages) VALUES (%s, %s, %s) RETURNING conversation_id",
        (user_id, conversation_id, [message])
    )

    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"conversation_id": conversation_id}), 201

@conversation_bp.route('/conversations/<conversation_id>', methods=['PUT'])
def update_conversation(conversation_id):
    data = request.get_json()
    user_id = data.get('user_id')
    message = data.get('message')

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        "UPDATE conversations SET messages = array_append(messages, %s), updated_at = CURRENT_TIMESTAMP WHERE conversation_id = %s AND user_id = %s",
        (message, conversation_id, user_id)
    )

    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"status": "updated"}), 200
