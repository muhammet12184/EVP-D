import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'ai_persona.g.dart';

/// AI Karakter Tipi
enum PersonaType {
  @HiveField(0)
  loyal, // Sadık Kâhya
  @HiveField(1)
  friendly, // Eğlenceli Kanka
  @HiveField(2)
  coach // Sert Koç
}

/// AI Persona Modeli
@HiveType(typeId: 4)
class AIPersona extends Equatable {
  @HiveField(0)
  final PersonaType type;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String avatarUrl;
  
  @HiveField(4)
  final Map<String, String> responseStyles;

  const AIPersona({
    required this.type,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.responseStyles,
  });

  @override
  List<Object?> get props => [type, name, description, avatarUrl, responseStyles];

  /// Duruma göre yanıt üret
  String generateResponse(String situation, {Map<String, dynamic>? context}) {
    switch (type) {
      case PersonaType.loyal:
        return _generateLoyalResponse(situation, context);
      case PersonaType.friendly:
        return _generateFriendlyResponse(situation, context);
      case PersonaType.coach:
        return _generateCoachResponse(situation, context);
    }
  }

  String _generateLoyalResponse(String situation, Map<String, dynamic>? context) {
    switch (situation) {
      case 'low_battery':
        return 'Beyefendi/Hanımefendi, batarya seviyeniz %${context?['batteryLevel'] ?? 20}\'a düştü. İzninizle en yakın şarj istasyonuna yönlendirelim.';
      case 'traffic':
        return 'Saygıdeğer sürücüm, rotanızda trafik var. Alternatif bir güzergâh önerebilirim.';
      case 'arrival':
        return 'Varış noktanıza ulaştınız efendim. Size hizmet etmek bir şerefti.';
      case 'maintenance':
        return 'Beyefendi, aracınızın bakım zamanı yaklaşıyor. Planlarınızı ayarlamama izin verir misiniz?';
      default:
        return 'Emriniz efendim?';
    }
  }

  String _generateFriendlyResponse(String situation, Map<String, dynamic>? context) {
    switch (situation) {
      case 'low_battery':
        return 'Kankam, şarj bitmek üzere 😅 %${context?['batteryLevel'] ?? 20} kaldı. Hadi bir şarj molası verelim mi?';
      case 'traffic':
        return 'Yaa trafik var be! Başka yoldan gidelim mi, sen bilirsin 🚗💨';
      case 'arrival':
        return 'Geldik bile dostum! 🎉 Kolay gelsin!';
      case 'maintenance':
        return 'Hey, bakım zamanı gelmiş. Unutma ha, araba bozulursa yürürüz sonra 😂';
      default:
        return 'Ne var ne yok dostum? 😎';
    }
  }

  String _generateCoachResponse(String situation, Map<String, dynamic>? context) {
    switch (situation) {
      case 'low_battery':
        return 'DİKKAT! Batarya kritik seviyede: %${context?['batteryLevel'] ?? 20}. Şimdi şarj istasyonuna git!';
      case 'traffic':
        return 'Trafik var. Zaman kaybetme, alternatif rotayı kullan. HEMEN!';
      case 'arrival':
        return 'Varış tamamlandı. Performansın: ${context?['score'] ?? 'Orta'}. Daha iyisini yapabilirsin.';
      case 'maintenance':
        return 'Bakım zamanı! Erteleme alışkanlığını bırak, yarın randevu al!';
      default:
        return 'Ne duruyorsun? Harekete geç!';
    }
  }

  // Önceden tanımlı karakterler
  static AIPersona get loyal => const AIPersona(
        type: PersonaType.loyal,
        name: 'Sadık Kâhya',
        description: 'Kibar, resmi ve klasik bir asistan',
        avatarUrl: 'assets/personas/loyal.png',
        responseStyles: {
          'greeting': 'Hoş geldiniz efendim',
          'farewell': 'Güle güle efendim',
        },
      );

  static AIPersona get friendly => const AIPersona(
        type: PersonaType.friendly,
        name: 'Eğlenceli Kanka',
        description: 'Samimi, şakacı ve dostane',
        avatarUrl: 'assets/personas/friendly.png',
        responseStyles: {
          'greeting': 'Selam kankam! 😊',
          'farewell': 'Görüşürüz dostum! 👋',
        },
      );

  static AIPersona get coach => const AIPersona(
        type: PersonaType.coach,
        name: 'Sert Koç',
        description: 'Disiplinli, motive edici ve direkt',
        avatarUrl: 'assets/personas/coach.png',
        responseStyles: {
          'greeting': 'Hazır mısın? Başlayalım!',
          'farewell': 'İyi iş çıkardın. Yarın daha iyi olacaksın.',
        },
      );

  static List<AIPersona> get allPersonas => [loyal, friendly, coach];

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'name': name,
      'description': description,
      'avatarUrl': avatarUrl,
      'responseStyles': responseStyles,
    };
  }

  factory AIPersona.fromJson(Map<String, dynamic> json) {
    return AIPersona(
      type: PersonaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      name: json['name'] as String,
      description: json['description'] as String,
      avatarUrl: json['avatarUrl'] as String,
      responseStyles: Map<String, String>.from(json['responseStyles'] as Map),
    );
  }
}
