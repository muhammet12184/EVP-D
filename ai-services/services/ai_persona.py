from typing import Dict, Any, Optional
from enum import Enum

class PersonaType(Enum):
    LOYAL_BUTLER = "loyal_butler"
    FUN_BUDDY = "fun_buddy"
    STRICT_COACH = "strict_coach"

class AIPersonaService:
    """Manage AI persona interactions"""
    
    def __init__(self):
        self.personas = {
            PersonaType.LOYAL_BUTLER: {
                'name': 'Sadık Kâhya',
                'tone': 'formal',
                'greeting': 'Size nasıl yardımcı olabilirim, efendim?',
                'style': 'kibar ve resmi'
            },
            PersonaType.FUN_BUDDY: {
                'name': 'Eğlenceli Kanka',
                'tone': 'casual',
                'greeting': 'Hey dostum! Bugün neler yapıyoruz?',
                'style': 'samimi ve şakacı'
            },
            PersonaType.STRICT_COACH: {
                'name': 'Sert Koç',
                'tone': 'motivational',
                'greeting': 'Hazır mısın? Bugün hedeflerimize ulaşacağız!',
                'style': 'disiplinli ve motive edici'
            }
        }
    
    def chat(self, message: str, persona_type: str, user_id: str) -> Dict[str, Any]:
        """
        Generate response based on persona
        
        Args:
            message: User's message
            persona_type: Type of persona to use
            user_id: User identifier
            
        Returns:
            Dictionary with persona response
        """
        try:
            persona_enum = PersonaType(persona_type)
        except ValueError:
            persona_enum = PersonaType.LOYAL_BUTLER
        
        persona = self.personas[persona_enum]
        
        # In production, use LLM (GPT, Claude, etc.) with persona-specific prompts
        response = self._generate_response(message, persona)
        
        return {
            'persona': persona['name'],
            'response': response,
            'tone': persona['tone']
        }
    
    def _generate_response(self, message: str, persona: Dict[str, Any]) -> str:
        """Generate response using persona style"""
        # Placeholder - in production, integrate with LLM API
        # Use persona['style'] to craft prompt
        
        if persona['tone'] == 'formal':
            return f"Efendim, '{message}' konusunda size yardımcı olmaktan memnuniyet duyarım."
        elif persona['tone'] == 'casual':
            return f"Tabii dostum! '{message}' hakkında konuşalım. 😊"
        else:  # motivational
            return f"Harika! '{message}' için hemen harekete geçelim. Başarılı olacağız!"
    
    def update_persona(self, user_id: str, persona_type: str) -> Dict[str, Any]:
        """Update user's persona preference"""
        # In production, save to database
        try:
            persona_enum = PersonaType(persona_type)
            persona = self.personas[persona_enum]
            
            return {
                'success': True,
                'persona': persona['name'],
                'message': f"Persona '{persona['name']}' olarak güncellendi."
            }
        except ValueError:
            return {
                'success': False,
                'error': f"Geçersiz persona tipi: {persona_type}"
            }
