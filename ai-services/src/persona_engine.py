"""
Persona Engine
Generates AI assistant responses based on selected persona
"""

from typing import Dict, Optional


class PersonaEngine:
    """Generates persona-specific responses"""
    
    PERSONAS = {
        "sadik_kahya": {
            "name": "Sadık Kâhya",
            "tone": "formal",
            "greeting": "Merhaba efendim, size nasıl yardımcı olabilirim?",
            "responses": {
                "default": "Tabii ki efendim, hemen yapıyorum.",
                "error": "Özür dilerim efendim, bir sorun oluştu.",
                "success": "Tamamlandı efendim, başka bir şey ister misiniz?",
            },
        },
        "eglenceli_kanka": {
            "name": "Eğlenceli Kanka",
            "tone": "casual",
            "greeting": "Selam dostum! Bugün ne yapıyoruz? 🚗💨",
            "responses": {
                "default": "Hemen hallediyorum kanka! 😎",
                "error": "Vay be, bir şeyler ters gitti ama sorun değil! 🔧",
                "success": "Tamamdır dostum! Başka ne var? 🎉",
            },
        },
        "sert_koc": {
            "name": "Sert Koç",
            "tone": "motivational",
            "greeting": "Hazır mısın? Bugün daha iyi olacağız!",
            "responses": {
                "default": "Hadi, yapalım bunu! Zor değil!",
                "error": "Sorun yok, tekrar dene! Pes etme!",
                "success": "İşte bu! Devam et, daha iyisini yapabilirsin!",
            },
        },
    }
    
    async def generate_response(
        self,
        persona_type: str,
        user_input: str,
        context: Optional[Dict] = None,
    ) -> Dict:
        """Generates response based on persona"""
        persona = self.PERSONAS.get(persona_type, self.PERSONAS["sadik_kahya"])
        
        # Simple response generation (would use LLM in production)
        response_type = self._determine_response_type(user_input)
        base_response = persona["responses"].get(response_type, persona["responses"]["default"])
        
        # Customize based on input
        response = self._customize_response(base_response, user_input, persona)
        
        return {
            "response": response,
            "tone": persona["tone"],
            "emotion": self._determine_emotion(persona_type, user_input),
        }
    
    def _determine_response_type(self, user_input: str) -> str:
        """Determines response type from user input"""
        input_lower = user_input.lower()
        
        if any(word in input_lower for word in ["hata", "sorun", "çalışmıyor"]):
            return "error"
        if any(word in input_lower for word in ["teşekkür", "sağol", "tamam"]):
            return "success"
        
        return "default"
    
    def _customize_response(
        self, base_response: str, user_input: str, persona: Dict
    ) -> str:
        """Customizes response based on user input"""
        # Simple customization (would use LLM in production)
        return base_response
    
    def _determine_emotion(self, persona_type: str, user_input: str) -> str:
        """Determines emotional tone of response"""
        emotion_map = {
            "sadik_kahya": "respectful",
            "eglenceli_kanka": "enthusiastic",
            "sert_koc": "motivational",
        }
        return emotion_map.get(persona_type, "neutral")
