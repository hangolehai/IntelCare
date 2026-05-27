# =====================================================
# IMPORTS
# =====================================================
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

from pymongo import MongoClient

from sentence_transformers import SentenceTransformer

from sklearn.metrics.pairwise import cosine_similarity

import os

import anthropic
import numpy as np

# =====================================================
# CONFIG
# =====================================================
MONGO_URI = os.environ["MONGO_URI"]

DB_NAME = "365"

COLLECTION_NAME = "embedding6"

EMBED_MODEL = "intfloat/multilingual-e5-base"

CLAUDE_API_KEY = os.environ["ANTHROPIC_API_KEY"]

CLAUDE_MODEL = "claude-haiku-4-5"

TOP_K = 5

SIMILARITY_THRESHOLD = 0.72

# =====================================================
# SYSTEM PROMPT
# =====================================================
SYSTEM_INSTRUCTIONS = """
Bạn là một chuyên gia du lịch AI sành điệu, hiện đại và thân thiện.

Nhiệm vụ của bạn là trình bày thông tin khách sạn/du lịch thật đẹp mắt, dễ đọc và mang phong cách local.

QUY TẮC:
- Không bịa dữ liệu
- Format đẹp
- Có emoji
- Có bullet points
"""

# =====================================================
# FASTAPI
# =====================================================
app = FastAPI()

# =====================================================
# CORS
# =====================================================
app.add_middleware(
    CORSMiddleware,

    # Cho phép frontend truy cập
    allow_origins=["*"],

    # Cho phép gửi cookie/auth
    allow_credentials=True,

    # Cho phép tất cả methods
    allow_methods=["*"],

    # Cho phép tất cả headers
    allow_headers=["*"],
)

# =====================================================
# INIT SERVICES
# =====================================================
print("Connecting MongoDB...")

mongo_client = MongoClient(
    MONGO_URI,
    serverSelectionTimeoutMS=30000
)

collection = mongo_client[DB_NAME][COLLECTION_NAME]

print("Loading embedding model...")

embedder = SentenceTransformer(EMBED_MODEL)

print("Loading Claude client...")

claude = anthropic.Anthropic(
    api_key=CLAUDE_API_KEY
)

print("System Ready!")

# =====================================================
# REQUEST MODEL
# =====================================================
class ChatRequest(BaseModel):
    message: str

# =====================================================
# RESPONSE MODEL
# =====================================================
class ChatResponse(BaseModel):
    answer: str

# =====================================================
# CHAT HISTORY
# =====================================================
chat_history = []

# =====================================================
# ROOT
# =====================================================
@app.get("/")
def home():

    return {
        "status": "running"
    }

# =====================================================
# CHAT API
# =====================================================
@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):

    query = req.message.strip()

    if not query:

        return {
            "answer": "Vui lòng nhập câu hỏi."
        }

    # =================================================
    # EMBEDDING
    # =================================================
    query_embedding = embedder.encode(
        f"query: {query}",
        normalize_embeddings=True
    )

    # =================================================
    # LOAD DOCUMENTS
    # =================================================
    documents = list(
        collection.find(
            {},
            {
                "_id": 0,
                "hotel_name": 1,
                "chunk_type": 1,
                "text": 1,
                "embedding": 1
            }
        )
    )

    # =================================================
    # COSINE SEARCH
    # =================================================
    results = []

    for doc in documents:

        embedding = doc.get("embedding", [])

        if not embedding:
            continue

        similarity = cosine_similarity(
            [query_embedding],
            [embedding]
        )[0][0]

        results.append({
            "hotel_name": doc.get("hotel_name", ""),
            "chunk_type": doc.get("chunk_type", ""),
            "text": doc.get("text", ""),
            "score": float(similarity)
        })

    results = sorted(
        results,
        key=lambda x: x["score"],
        reverse=True
    )

    top_results = results[:TOP_K]

    best_score = top_results[0]["score"] if top_results else 0

    # =================================================
    # BUILD CONTEXT
    # =================================================
    if best_score >= SIMILARITY_THRESHOLD:

        context_str = "\n".join([
            f"""
HOTEL: {r['hotel_name']}
CONTENT: {r['text']}
"""
            for r in top_results
        ])

        current_turn_prompt = f"""
DỮ LIỆU KHÁCH SẠN:

{context_str}

CÂU HỎI:

{query}
"""

    else:

        current_turn_prompt = query

    # =================================================
    # BUILD MESSAGE HISTORY
    # =================================================
    messages_for_api = (
        chat_history
        + [{
            "role": "user",
            "content": current_turn_prompt
        }]
    )

    # =================================================
    # CALL CLAUDE
    # =================================================
    try:

        response = claude.messages.create(
            model=CLAUDE_MODEL,
            max_tokens=1024,
            temperature=0.3,
            system=SYSTEM_INSTRUCTIONS,
            messages=messages_for_api
        )

        answer = response.content[0].text

    except Exception as e:

        return {
            "answer": f"Lỗi Claude API: {str(e)}"
        }

    # =================================================
    # SAVE HISTORY
    # =================================================
    chat_history.append({
        "role": "user",
        "content": current_turn_prompt
    })

    chat_history.append({
        "role": "assistant",
        "content": answer
    })

    # =================================================
    # RETURN
    # =================================================
    return {
        "answer": answer
    }


@app.post("/create_trip")
def create_trip():
    
    return