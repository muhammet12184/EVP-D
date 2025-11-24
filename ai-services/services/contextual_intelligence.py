from typing import Dict, Any, List
import re

class ContextualIntelligence:
    """Process contextual commands and understand user intent"""
    
    def __init__(self):
        # Contextual command mappings
        self.command_patterns = {
            'cold': {
                'keywords': ['üşüdüm', 'soğuk', 'donuyorum', 'titriyorum'],
                'actions': ['climate_on', 'temperature_increase'],
                'default_action': 'climate_on'
            },
            'hot': {
                'keywords': ['sıcak', 'terliyorum', 'bunalıyorum'],
                'actions': ['climate_on', 'temperature_decrease'],
                'default_action': 'climate_on'
            },
            'tired': {
                'keywords': ['yorgunum', 'uyuyorum', 'uyku'],
                'actions': ['suggest_rest', 'play_energizing_music'],
                'default_action': 'suggest_rest'
            },
            'thirsty': {
                'keywords': ['susadım', 'su', 'içecek'],
                'actions': ['suggest_nearby_cafe', 'navigate_to_restaurant'],
                'default_action': 'suggest_nearby_cafe'
            },
            'hungry': {
                'keywords': ['açım', 'yemek', 'açlık'],
                'actions': ['suggest_nearby_restaurant', 'navigate_to_restaurant'],
                'default_action': 'suggest_nearby_restaurant'
            }
        }
    
    def process_command(self, command: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Process contextual command
        
        Args:
            command: User's command (e.g., "Üşüdüm")
            context: Additional context (location, time, vehicle state, etc.)
            
        Returns:
            Dictionary with interpreted command and actions
        """
        if context is None:
            context = {}
        
        command_lower = command.lower()
        
        # Find matching pattern
        matched_pattern = None
        for pattern_name, pattern_data in self.command_patterns.items():
            for keyword in pattern_data['keywords']:
                if keyword in command_lower:
                    matched_pattern = pattern_data
                    break
            if matched_pattern:
                break
        
        if not matched_pattern:
            # No pattern matched, return original command
            return {
                'original_command': command,
                'interpreted': False,
                'actions': []
            }
        
        # Determine action based on context
        action = self._determine_action(matched_pattern, context)
        
        return {
            'original_command': command,
            'interpreted': True,
            'intent': matched_pattern.get('intent', 'unknown'),
            'actions': [action],
            'confidence': 0.9
        }
    
    def _determine_action(self, pattern: Dict[str, Any], context: Dict[str, Any]) -> str:
        """Determine the best action based on pattern and context"""
        # Simple logic - in production, use ML model
        return pattern['default_action']
    
    def get_proactive_suggestions(self, user_id: str, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Generate proactive suggestions based on context
        
        Args:
            user_id: User identifier
            context: Current context (location, time, calendar, etc.)
            
        Returns:
            List of proactive suggestions
        """
        suggestions = []
        
        # Example: If it's morning and user is near coffee shop
        time_of_day = context.get('time_of_day', '')
        location = context.get('location', {})
        nearby_places = context.get('nearby_places', [])
        
        if time_of_day == 'morning' and 'coffee' in str(nearby_places).lower():
            suggestions.append({
                'type': 'coffee_suggestion',
                'message': 'Sabah kahvenizi almak için yakındaki bir kafeye uğrayalım mı?',
                'action': 'navigate_to_coffee_shop'
            })
        
        return suggestions
