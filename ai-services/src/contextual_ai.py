"""
Contextual AI Service
Understands natural language commands with context
"""

from typing import Dict, Optional
import re


class ContextualAI:
    """Processes contextual natural language commands"""
    
    def __init__(self):
        # Command patterns with context understanding
        self.command_patterns = {
            "cold": {
                "patterns": [r"üşüdüm", r"soğuk", r"donuyorum", r"ısıt"],
                "action": "turn_on_heating",
                "parameters": {"temperature": 24},
            },
            "hot": {
                "patterns": [r"sıcak", r"bunalıyorum", r"klima", r"serinlet"],
                "action": "turn_on_cooling",
                "parameters": {"temperature": 20},
            },
            "tired": {
                "patterns": [r"yorgunum", r"uykum var", r"dinlen"],
                "action": "find_rest_stop",
                "parameters": {},
            },
            "hungry": {
                "patterns": [r"açım", r"açlık", r"yemek"],
                "action": "find_restaurant",
                "parameters": {},
            },
            "music": {
                "patterns": [r"müzik", r"şarkı", r"aç"],
                "action": "play_music",
                "parameters": {"genre": "relaxing"},
            },
        }
    
    async def process_command(
        self, command: str, context: Dict
    ) -> Dict:
        """Processes natural language command with context"""
        command_lower = command.lower()
        
        # Check against patterns
        for intent, config in self.command_patterns.items():
            for pattern in config["patterns"]:
                if re.search(pattern, command_lower):
                    # Enhance with context
                    parameters = self._enhance_with_context(
                        config["parameters"], context
                    )
                    
                    return {
                        "interpreted_command": config["action"],
                        "confidence": 0.92,
                        "action_taken": True,
                        "parameters": parameters,
                    }
        
        # Default: try to understand generic command
        return {
            "interpreted_command": "unknown",
            "confidence": 0.3,
            "action_taken": False,
            "parameters": {},
        }
    
    def _enhance_with_context(
        self, parameters: Dict, context: Dict
    ) -> Dict:
        """Enhances parameters with context information"""
        enhanced = parameters.copy()
        
        # Add location context
        if "location" in context:
            enhanced["location"] = context["location"]
        
        # Add time context
        if "time_of_day" in context:
            enhanced["time_of_day"] = context["time_of_day"]
        
        # Add user preferences
        if "preferences" in context:
            enhanced.update(context["preferences"])
        
        return enhanced
