from typing import Dict, Any, List, Optional
from datetime import datetime, time
import json

class LearningEngine:
    """Learn user patterns and habits"""
    
    def __init__(self):
        # In production, use database or ML models
        self.user_patterns = {}
    
    def learn_pattern(self, user_id: str, pattern_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Learn a pattern from user behavior
        
        Args:
            user_id: User identifier
            pattern_data: Pattern data (route, time, action, etc.)
            
        Returns:
            Confirmation of learned pattern
        """
        if user_id not in self.user_patterns:
            self.user_patterns[user_id] = []
        
        pattern = {
            'timestamp': datetime.now().isoformat(),
            'data': pattern_data
        }
        
        self.user_patterns[user_id].append(pattern)
        
        return {
            'success': True,
            'message': 'Pattern learned successfully',
            'pattern_id': len(self.user_patterns[user_id])
        }
    
    def predict_action(self, user_id: str, current_context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Predict user's next action based on learned patterns
        
        Args:
            user_id: User identifier
            current_context: Current context (location, time, etc.)
            
        Returns:
            Prediction with confidence score
        """
        if user_id not in self.user_patterns:
            return {
                'prediction': None,
                'confidence': 0.0,
                'message': 'No patterns learned yet'
            }
        
        # Simple pattern matching - in production, use ML models
        patterns = self.user_patterns[user_id]
        current_time = current_context.get('time', datetime.now().time())
        current_location = current_context.get('location', {})
        
        # Find similar patterns
        similar_patterns = []
        for pattern in patterns:
            pattern_time = pattern['data'].get('time')
            pattern_location = pattern['data'].get('location', {})
            
            # Check time similarity (within 1 hour)
            if pattern_time:
                time_diff = abs((datetime.fromisoformat(pattern_time).time().hour - current_time.hour))
                if time_diff <= 1:
                    similar_patterns.append(pattern)
        
        if similar_patterns:
            # Most common action in similar patterns
            actions = [p['data'].get('action') for p in similar_patterns]
            predicted_action = max(set(actions), key=actions.count) if actions else None
            
            return {
                'prediction': predicted_action,
                'confidence': len(similar_patterns) / len(patterns),
                'message': f'Based on {len(similar_patterns)} similar patterns'
            }
        
        return {
            'prediction': None,
            'confidence': 0.0,
            'message': 'No similar patterns found'
        }
    
    def get_habits(self, user_id: str) -> List[Dict[str, Any]]:
        """Get learned habits for user"""
        if user_id not in self.user_patterns:
            return []
        
        # Analyze patterns to extract habits
        habits = []
        patterns = self.user_patterns[user_id]
        
        # Example: Find recurring routes
        routes = {}
        for pattern in patterns:
            route = pattern['data'].get('route')
            if route:
                routes[route] = routes.get(route, 0) + 1
        
        for route, count in routes.items():
            if count >= 3:  # Habit threshold
                habits.append({
                    'type': 'route',
                    'description': f'Regular route: {route}',
                    'frequency': count
                })
        
        return habits
