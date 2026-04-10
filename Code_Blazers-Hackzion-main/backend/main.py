from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routers import transactions, subscriptions, goals, ai, ocr, auth

# ──────────────────────────────────────────────
# FastAPI App
# ──────────────────────────────────────────────
app = FastAPI(
    title="FinSight Backend",
    description=(
        "AI-powered personal finance backend. "
        "Supports transaction management, receipt OCR via DocTR, "
        "AI financial chatbot via Gemma (Ollama), subscription tracking, and goal planning."
    ),
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Allow Flutter frontend to connect (adjust origins for production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ──────────────────────────────────────────────
# Include Routers
# ──────────────────────────────────────────────
app.include_router(transactions.router)
app.include_router(subscriptions.router)
app.include_router(goals.router)
app.include_router(ai.router)
app.include_router(ocr.router)
app.include_router(auth.router)


# ──────────────────────────────────────────────
# Health Check
# ──────────────────────────────────────────────
@app.get("/", tags=["Health"])
def health_check():
    return {
        "status": "healthy",
        "service": "FinSight Backend",
        "version": "2.0.0",
        "docs": "/docs"
    }
