import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Get the API key from environment variables
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# If the API key is not found, ask the user to input it
if not OPENAI_API_KEY:
    print("No API key found in environment variables.")
    OPENAI_API_KEY = input("Please enter your OPENAI_API_KEY: ")

# Now you can use the API key
print("Using OpenAI API key:", OPENAI_API_KEY)
