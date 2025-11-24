import '../../shared/models/ai_persona.dart';

/// AI Asistan Servisi
class AIService {
  AIPersona? _currentPersona;

  /// Seçili karakteri al
  AIPersona? get currentPersona => _currentPersona;

  /// Karakter seç
  void selectPersona(PersonaType type) {
    switch (type) {
      case PersonaType.loyal:
        _currentPersona = AIPersona.loyal;
        break;
      case PersonaType.friendly:
        _currentPersona = AIPersona.friendly;
        break;
      case PersonaType.coach:
        _currentPersona = AIPersona.coach;
        break;
    }
  }

  /// Duruma göre yanıt al
  String getResponse(String situation, {Map<String, dynamic>? context}) {
    if (_currentPersona == null) {
      selectPersona(PersonaType.loyal); // Varsayılan karakter
    }
    return _currentPersona!.generateResponse(situation, context: context);
  }

  /// Duygu analizi (basitleştirilmiş)
  String analyzeMood(String userInput) {
    // Gerçek uygulamada burada TensorFlow Lite veya başka bir ML modeli kullanılacak
    final lowerInput = userInput.toLowerCase();
    
    if (lowerInput.contains('yorgun') || 
        lowerInput.contains('stresli') || 
        lowerInput.contains('sinirli')) {
      return 'stressed';
    } else if (lowerInput.contains('mutlu') || 
               lowerInput.contains('iyi') || 
               lowerInput.contains('harika')) {
      return 'happy';
    } else if (lowerInput.contains('üşüdüm') || 
               lowerInput.contains('sıcak') || 
               lowerInput.contains('soğuk')) {
      return 'uncomfortable';
    }
    
    return 'neutral';
  }

  /// Bağlamsal komut yorumlama
  Map<String, dynamic> interpretCommand(String command) {
    final lowerCommand = command.toLowerCase();
    
    // Sıcaklık kontrolleri
    if (lowerCommand.contains('üşü') || lowerCommand.contains('soğuk')) {
      return {
        'action': 'climate_control',
        'type': 'increase_temperature',
        'value': 2,
      };
    }
    
    if (lowerCommand.contains('sıcak')) {
      return {
        'action': 'climate_control',
        'type': 'decrease_temperature',
        'value': 2,
      };
    }
    
    // Müzik kontrolleri
    if (lowerCommand.contains('müzik') || lowerCommand.contains('şarkı')) {
      if (lowerCommand.contains('aç') || lowerCommand.contains('çal')) {
        return {
          'action': 'music',
          'type': 'play',
        };
      } else if (lowerCommand.contains('kapat') || lowerCommand.contains('durdur')) {
        return {
          'action': 'music',
          'type': 'stop',
        };
      }
    }
    
    // Navigasyon
    if (lowerCommand.contains('ev') && (lowerCommand.contains('git') || lowerCommand.contains('yol'))) {
      return {
        'action': 'navigation',
        'type': 'go_home',
      };
    }
    
    if (lowerCommand.contains('iş') && (lowerCommand.contains('git') || lowerCommand.contains('yol'))) {
      return {
        'action': 'navigation',
        'type': 'go_to_work',
      };
    }
    
    // Şarj/Yakıt istasyonu
    if (lowerCommand.contains('şarj') || lowerCommand.contains('yakıt') || lowerCommand.contains('benzin')) {
      return {
        'action': 'find_station',
        'type': lowerCommand.contains('şarj') ? 'charging' : 'fuel',
      };
    }
    
    return {
      'action': 'unknown',
      'original': command,
    };
  }

  /// Proaktif öneri üret (takvim ve konum bazlı)
  String generateProactiveSuggestion({
    required DateTime currentTime,
    required String currentLocation,
    Map<String, dynamic>? calendarEvent,
  }) {
    if (calendarEvent != null) {
      final eventTime = calendarEvent['time'] as DateTime;
      final eventLocation = calendarEvent['location'] as String;
      
      // Etkinliğe 30 dakika kala uyar
      final difference = eventTime.difference(currentTime);
      if (difference.inMinutes <= 30 && difference.inMinutes > 0) {
        return getResponse('calendar_reminder', context: {
          'eventName': calendarEvent['title'],
          'eventLocation': eventLocation,
          'minutesLeft': difference.inMinutes,
        });
      }
    }
    
    // Sabah rutini
    if (currentTime.hour >= 7 && currentTime.hour <= 9) {
      return getResponse('morning_routine', context: {
        'time': '${currentTime.hour}:${currentTime.minute}',
      });
    }
    
    return '';
  }
}
