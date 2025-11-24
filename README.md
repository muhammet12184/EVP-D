# New Generation Mobility and Life Ecosystem (Super App)

## Project Overview
This is a "Super App" ecosystem combining Mobility, Finance, and AI Assistance. It integrates Electric Vehicle (EV) and ICE vehicle data, providing a personalized experience through AI personas.

## Architecture
The project consists of three main components:

1.  **Mobile App (Flutter)**: The user interface for iOS and Android.
    *   Location: `super_app/mobile`
    *   Features: Persona selection, Dashboard, Navigation (Mapbox integration planned).
    *   *Note: Requires Flutter SDK installed to run.*

2.  **Backend (Go/Golang)**: High-performance server handling data, auth, and vehicle logic.
    *   Location: `super_app/backend`
    *   Features: EV Data Specs API (`/api/ev-specs`), Health check.
    *   Data: Loads `ev_unified_professional.csv` for vehicle specific parameters.

3.  **AI Service (Python)**: Intelligent service for Persona logic and sentiment analysis.
    *   Location: `super_app/ai`
    *   Features: Sentiment Analysis endpoint with Persona support (Butler, Buddy, Coach).
    *   Tech: FastAPI, Pandas.

## Getting Started

### Backend
```bash
cd super_app/backend
go run main.go
# Server running at http://localhost:8080
# Test: curl http://localhost:8080/api/ev-specs
```

### AI Service
```bash
cd super_app/ai
pip install -r requirements.txt
uvicorn main:app --reload
# Service running at http://localhost:8000
# Test: curl -X POST "http://localhost:8000/analyze-sentiment" -H "Content-Type: application/json" -d '{"text": "Hello", "persona": "buddy"}'
```

### Mobile App
```bash
cd super_app/mobile
flutter pub get
flutter run
```

## Features Implemented (Proof of Concept)
*   **AI Persona**: Basic logic in Python service to respond differently based on selected persona.
*   **EV Data**: Parsing logic for `ev_unified_professional.csv` in Go backend to serve vehicle parameters.
*   **Architecture**: Clean separation of concerns (Mobile, Backend, AI).
