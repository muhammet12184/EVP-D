import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/ai_persona_model.dart';

/// AI Service - Handles AI persona interactions, voice, and contextual intelligence
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  AIPersona? _currentPersona;
  bool _isListening = false;
  bool _isSpeaking = false;

  AIPersona? get currentPersona => _currentPersona;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;

  /// Initialize AI service
  Future<void> initialize() async {
    await _initializeTTS();
    await _initializeSpeech();
  }

  /// Initialize Text-to-Speech
  Future<void> _initializeTTS() async {
    await _tts.setLanguage('tr-TR');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      print('TTS Error: $msg');
    });
  }

  /// Initialize Speech Recognition
  Future<void> _initializeSpeech() async {
    await _speech.initialize(
      onError: (error) => print('Speech Error: $error'),
      onStatus: (status) => print('Speech Status: $status'),
    );
  }

  /// Set active AI persona
  Future<void> setPersona(AIPersona persona) async {
    _currentPersona = persona;
    
    // Update TTS settings based on persona
    await _tts.setSpeechRate(persona.speechSpeed);
    await _tts.setPitch(persona.pitchLevel);
    
    // Greet user with new persona
    await speak(persona.getRandomGreeting());
  }

  /// Speak text using current persona's voice
  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await _tts.stop();
    }
    await _tts.speak(text);
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  /// Start listening to user voice
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onError,
  }) async {
    if (!_speech.isAvailable) {
      onError?.call('Speech recognition not available');
      return;
    }

    _isListening = true;
    
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'tr_TR',
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  /// Process natural language command
  Future<String> processCommand(String command) async {
    final lowerCommand = command.toLowerCase();
    
    // Context detection
    if (lowerCommand.contains('üşü') || lowerCommand.contains('soğuk')) {
      return await _handleContext('cold');
    } else if (lowerCommand.contains('sıcak') || lowerCommand.contains('terledim')) {
      return await _handleContext('hot');
    } else if (lowerCommand.contains('yorgun') || lowerCommand.contains('uykum var')) {
      return await _handleContext('tired');
    } else if (lowerCommand.contains('kaybol') || lowerCommand.contains('neredeyim')) {
      return await _handleContext('lost');
    }
    
    // Direct commands
    if (lowerCommand.contains('klima')) {
      if (lowerCommand.contains('aç') || lowerCommand.contains('açar mısın')) {
        return await _executeCommand('climate_on');
      } else if (lowerCommand.contains('kapat')) {
        return await _executeCommand('climate_off');
      }
    }
    
    if (lowerCommand.contains('müzik')) {
      if (lowerCommand.contains('aç') || lowerCommand.contains('çal')) {
        return await _executeCommand('music_play');
      } else if (lowerCommand.contains('kapat') || lowerCommand.contains('durdur')) {
        return await _executeCommand('music_stop');
      }
    }

    if (lowerCommand.contains('şarj') || lowerCommand.contains('batarya')) {
      return await _executeCommand('battery_status');
    }

    if (lowerCommand.contains('yakıt')) {
      return await _executeCommand('fuel_status');
    }

    if (lowerCommand.contains('navigasyon') || lowerCommand.contains('yol tarifi')) {
      return await _executeCommand('navigation');
    }

    // Default response
    return _currentPersona?.getRandomAcknowledgment() ?? 
           'Anlayamadım, tekrar söyler misiniz?';
  }

  /// Handle contextual responses
  Future<String> _handleContext(String context) async {
    if (_currentPersona == null) {
      return 'Persona seçilmedi';
    }

    final response = _currentPersona!.getContextualResponse(context);
    if (response != null) {
      await speak(response);
      
      // Execute related action
      switch (context) {
        case 'hot':
          // Send climate control command
          break;
        case 'cold':
          // Send heating command
          break;
        case 'tired':
          // Find nearby rest area
          break;
        case 'lost':
          // Recalculate route
          break;
      }
      
      return response;
    }

    return _currentPersona!.getRandomAcknowledgment();
  }

  /// Execute specific command
  Future<String> _executeCommand(String command) async {
    // This would integrate with vehicle systems via AWS IoT
    // For now, return persona-based responses
    
    switch (command) {
      case 'climate_on':
        return _getPersonaResponse('Klimayı açıyorum.');
      case 'climate_off':
        return _getPersonaResponse('Klimayı kapatıyorum.');
      case 'music_play':
        return _getPersonaResponse('Müziği başlatıyorum.');
      case 'music_stop':
        return _getPersonaResponse('Müziği durdurdum.');
      case 'battery_status':
        return _getPersonaResponse('Batarya seviyenizi kontrol ediyorum.');
      case 'fuel_status':
        return _getPersonaResponse('Yakıt seviyenizi kontrol ediyorum.');
      case 'navigation':
        return _getPersonaResponse('Navigasyonu başlatıyorum.');
      default:
        return _getPersonaResponse('Anlaşıldı.');
    }
  }

  /// Get persona-appropriate response
  String _getPersonaResponse(String baseMessage) {
    if (_currentPersona == null) return baseMessage;

    switch (_currentPersona!.type) {
      case AIPersonaType.kahya:
        return 'Emredersiniz efendim, $baseMessage';
      case AIPersonaType.kanka:
        return 'Tamam kankam! $baseMessage';
      case AIPersonaType.koc:
        return 'Anlaşıldı! $baseMessage';
    }
  }

  /// Analyze user emotion (placeholder for ML integration)
  Future<String> analyzeEmotion() async {
    // This would integrate with TensorFlow Lite for facial/voice emotion detection
    // For now, return neutral
    return 'neutral';
  }

  /// Proactive suggestions based on context
  Future<String?> getProactiveSuggestion({
    required DateTime currentTime,
    required String location,
    required Map<String, dynamic> vehicleData,
  }) async {
    // Morning coffee routine
    if (currentTime.hour >= 7 && currentTime.hour <= 9) {
      if (location.contains('work') || location.contains('iş')) {
        return 'Günaydın! Her zamanki kahve duraklarınızdan birine uğramak ister misiniz?';
      }
    }

    // Low battery/fuel warning
    if (vehicleData['batteryLevel'] != null && vehicleData['batteryLevel'] < 20) {
      return 'Batarya seviyeniz düşük. Yakındaki şarj istasyonlarını göstereyim mi?';
    }

    if (vehicleData['fuelLevel'] != null && vehicleData['fuelLevel'] < 20) {
      return 'Yakıt seviyeniz düşük. En uygun istasyonu bulayım mı?';
    }

    // Service reminder
    if (vehicleData['serviceDate'] != null) {
      final serviceDate = vehicleData['serviceDate'] as DateTime;
      final daysUntil = serviceDate.difference(DateTime.now()).inDays;
      if (daysUntil <= 7 && daysUntil > 0) {
        return 'Servis randevunuz $daysUntil gün sonra. Hatırlatmamı ister misiniz?';
      }
    }

    return null;
  }

  /// Dispose resources
  void dispose() {
    _tts.stop();
    _speech.stop();
  }
}
