from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="FastAPI Cloud Deploy",
    description="FastAPI application with Google Cloud Run deployment",
    version="0.1.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    """Root endpoint returning welcome message."""
    return {"message": "Welcome to FastAPI Cloud Deploy"}

@app.get("/health")
async def health():
    """Health check endpoint."""
    return {"status": "healthy"}
