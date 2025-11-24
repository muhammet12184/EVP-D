"""
Super Mobility AI Services
Main FastAPI application for AI-powered features
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import uvicorn

from src.emotion_analysis import EmotionAnalyzer
from src.contextual_ai import ContextualAI
from src.persona_engine import PersonaEngine
from src.range_calculator import RangeCalculator

app = FastAPI(title="Super Mobility AI Services", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize AI services
emotion_analyzer = EmotionAnalyzer()
contextual_ai = ContextualAI()
persona_engine = PersonaEngine()
range_calculator = RangeCalculator()


# Request/Response Models
class EmotionAnalysisRequest(BaseModel):
    image_data: Optional[str] = None  # Base64 encoded image
    audio_data: Optional[str] = None  # Base64 encoded audio
    text: Optional[str] = None


class EmotionAnalysisResponse(BaseModel):
    emotion_type: str
    intensity: float
    confidence: float
    suggestions: List[str]


class ContextualCommandRequest(BaseModel):
    command: str
    context: Optional[dict] = None


class ContextualCommandResponse(BaseModel):
    interpreted_command: str
    confidence: float
    action_taken: bool
    parameters: Optional[dict] = None


class RangeEstimateRequest(BaseModel):
    battery_capacity: float
    current_soc: float
    average_consumption: float
    weather_data: dict
    route_elevation: dict
    driving_history: List[dict]


class RangeEstimateResponse(BaseModel):
    estimated_range: float
    confidence: float
    factors: dict


class PersonaResponseRequest(BaseModel):
    persona_type: str
    user_input: str
    context: Optional[dict] = None


class PersonaResponseResponse(BaseModel):
    response: str
    tone: str
    emotion: str


# API Endpoints
@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "ai-services"}


@app.post("/emotion/analyze", response_model=EmotionAnalysisResponse)
async def analyze_emotion(request: EmotionAnalysisRequest):
    """Analyzes user emotion from image, audio, or text"""
    try:
        result = await emotion_analyzer.analyze(
            image_data=request.image_data,
            audio_data=request.audio_data,
            text=request.text,
        )
        return EmotionAnalysisResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/contextual/command", response_model=ContextualCommandResponse)
async def process_contextual_command(request: ContextualCommandRequest):
    """Processes natural language commands with context understanding"""
    try:
        result = await contextual_ai.process_command(
            command=request.command,
            context=request.context or {},
        )
        return ContextualCommandResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/range/estimate", response_model=RangeEstimateResponse)
async def estimate_range(request: RangeEstimateRequest):
    """Calculates realistic EV range with 99% accuracy"""
    try:
        result = await range_calculator.calculate(
            battery_capacity=request.battery_capacity,
            current_soc=request.current_soc,
            average_consumption=request.average_consumption,
            weather_data=request.weather_data,
            route_elevation=request.route_elevation,
            driving_history=request.driving_history,
        )
        return RangeEstimateResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/persona/respond", response_model=PersonaResponseResponse)
async def generate_persona_response(request: PersonaResponseRequest):
    """Generates AI assistant response based on selected persona"""
    try:
        result = await persona_engine.generate_response(
            persona_type=request.persona_type,
            user_input=request.user_input,
            context=request.context or {},
        )
        return PersonaResponseResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
