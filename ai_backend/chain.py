from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_qdrant import QdrantVectorStore
from langchain_voyageai import VoyageAIEmbeddings
import os
from qdrant_client import QdrantClient
from langchain.schema.runnable import Runnable
from dotenv import load_dotenv

load_dotenv()
voyage_api_key = os.getenv('VOYAGE_API_KEY')
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

def get_chain() -> Runnable:
  embeddings = VoyageAIEmbeddings(voyage_api_key=voyage_api_key,model = "voyage-large-2")
  client= QdrantClient(path="./tmp/langchain_qdrant")
  vector_store = QdrantVectorStore(
      client=client,
      collection_name="demo_collection",
      embedding=embeddings,
  )
  retriever = vector_store.as_retriever(search_kwargs={'k': 12})
  llm = ChatOpenAI(temperature=0, model="gpt-4o-mini", max_tokens=4069,api_key=OPENAI_API_KEY)

  system_prompt = (
    "You are an answering question based on Vietnamese financial reports snippets. "
    "Use the following pieces of retrieved context to answer "
    "the question. If you don't know the answer, say that you "
    "don't know. Keep the answer concise. Do not hallucinate."
    "Answer the questions in Vietnamese if the questions are asked in Vietnamese,"
    "English otherwise."
    "\n\n"
    "{context}"
  )

  prompt = ChatPromptTemplate.from_messages(
      [
        ("system", system_prompt),
        ("human", "{input}"),
      ]
  )
  qa_chain = create_stuff_documents_chain(llm, prompt)
  rag_chain = create_retrieval_chain(retriever, qa_chain)
  return rag_chain

