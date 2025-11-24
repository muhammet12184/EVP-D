from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
import pandas as pd
from typing import Optional

app = FastAPI(title="Super App AI Service")

class PersonaRequest(BaseModel):
    text: str
    persona: str  # "butler", "buddy", "coach"

@app.get("/")
def read_root():
    return {"message": "AI Service is ready"}

@app.post("/analyze-sentiment")
def analyze_sentiment(data: PersonaRequest):
    # Mock sentiment analysis
    # In a real app, we would use a model here
    response_text = ""
    if data.persona == "butler":
        response_text = f"Sir/Madam, I perceive you said: '{data.text}'. How may I assist?"
    elif data.persona == "buddy":
        response_text = f"Yo! You said '{data.text}'. That's cool!"
    elif data.persona == "coach":
        response_text = f"Listen up! You said '{data.text}'. Now get moving!"
    else:
        response_text = f"Processed: {data.text}"
    
    return {
        "sentiment": "neutral",
        "response": response_text,
        "persona": data.persona
    }

@app.get("/health")
def health_check():
    return {"status": "ok"}
