from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv

from services.emotion_analysis import EmotionAnalyzer
from services.contextual_intelligence import ContextualIntelligence
from services.ai_persona import AIPersonaService
from services.voice_processing import VoiceProcessor
from services.learning_engine import LearningEngine

load_dotenv()

app = Flask(__name__)
CORS(app)

# Initialize AI services
emotion_analyzer = EmotionAnalyzer()
contextual_intelligence = ContextualIntelligence()
persona_service = AIPersonaService()
voice_processor = VoiceProcessor()
learning_engine = LearningEngine()

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'ok',
        'service': 'ai-services'
    })

@app.route('/api/v1/emotion/analyze', methods=['POST'])
def analyze_emotion():
    """Analyze emotion from voice and/or facial expression"""
    try:
        data = request.json
        voice_data = data.get('voice')
        image_data = data.get('image')
        
        result = emotion_analyzer.analyze(voice_data, image_data)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/contextual/command', methods=['POST'])
def process_contextual_command():
    """Process contextual commands (e.g., "Üşüdüm" -> "Klimayı aç")"""
    try:
        data = request.json
        command = data.get('command')
        context = data.get('context', {})
        
        result = contextual_intelligence.process_command(command, context)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/persona/chat', methods=['POST'])
def persona_chat():
    """Chat with AI persona"""
    try:
        data = request.json
        message = data.get('message')
        persona_type = data.get('persona_type', 'loyal_butler')
        user_id = data.get('user_id')
        
        response = persona_service.chat(message, persona_type, user_id)
        return jsonify(response), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/persona/update', methods=['POST'])
def update_persona():
    """Update user's AI persona preference"""
    try:
        data = request.json
        user_id = data.get('user_id')
        persona_type = data.get('persona_type')
        
        result = persona_service.update_persona(user_id, persona_type)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/voice/process', methods=['POST'])
def process_voice():
    """Process voice input (speech-to-text)"""
    try:
        audio_file = request.files.get('audio')
        if not audio_file:
            return jsonify({'error': 'No audio file provided'}), 400
        
        text = voice_processor.speech_to_text(audio_file)
        return jsonify({'text': text}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/learning/learn', methods=['POST'])
def learn_pattern():
    """Learn user patterns and habits"""
    try:
        data = request.json
        user_id = data.get('user_id')
        pattern_data = data.get('pattern_data')
        
        result = learning_engine.learn_pattern(user_id, pattern_data)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/learning/predict', methods=['POST'])
def predict_action():
    """Predict user's next action based on learned patterns"""
    try:
        data = request.json
        user_id = data.get('user_id')
        current_context = data.get('current_context')
        
        prediction = learning_engine.predict_action(user_id, current_context)
        return jsonify(prediction), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/ev/range-prediction', methods=['POST'])
def predict_ev_range():
    """Predict EV range with high accuracy"""
    try:
        data = request.json
        battery_data = data.get('battery_data')
        weather_data = data.get('weather_data')
        elevation_data = data.get('elevation_data')
        driving_style = data.get('driving_style')
        
        # This would use ML models to predict range
        prediction = {
            'estimated_range_km': 0,
            'confidence': 0.0,
            'factors': {}
        }
        return jsonify(prediction), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/ice/diagnostics', methods=['POST'])
def interpret_diagnostics():
    """Interpret ICE vehicle diagnostic codes in plain language"""
    try:
        data = request.json
        dtc_codes = data.get('dtc_codes')
        
        interpretation = {
            'codes': dtc_codes,
            'interpretation': 'Motor arıza ışığı yandı. Oksijen sensörü kirlenmiş olabilir.',
            'severity': 'medium',
            'recommendation': 'Yakın zamanda servise götürmeniz önerilir.'
        }
        return jsonify(interpretation), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=True)
