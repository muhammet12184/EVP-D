import 'package:equatable/equatable.dart';

/// AI Persona types representing different assistant personalities
enum AIPersonaType {
  kahya, // Sadık Kâhya - Formal/Polite
  kanka, // Eğlenceli Kanka - Casual/Fun
  koc, // Sert Koç - Strict/Disciplined
}

/// AI Persona Model - Represents the selectable AI assistant character
class AIPersona extends Equatable {
  final String id;
  final AIPersonaType type;
  final String name;
  final String description;
  final String avatarUrl;
  final String voiceId;
  final List<String> greetings;
  final List<String> acknowledgments;
  final List<String> warnings;
  final Map<String, String> contextualResponses;
  final double speechSpeed; // 0.5 - 2.0
  final double pitchLevel; // 0.5 - 2.0
  final String personality;

  const AIPersona({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.voiceId,
    required this.greetings,
    required this.acknowledgments,
    required this.warnings,
    required this.contextualResponses,
    this.speechSpeed = 1.0,
    this.pitchLevel = 1.0,
    required this.personality,
  });

  /// Predefined AI Personas
  static const AIPersona kahya = AIPersona(
    id: 'kahya',
    type: AIPersonaType.kahya,
    name: 'Sadık Kâhya',
    description: 'Kibar, profesyonel ve size her zaman saygıyla yaklaşan asistanınız',
    avatarUrl: 'assets/ai_personas/kahya.png',
    voiceId: 'tr-formal-male',
    greetings: [
      'Sayın kullanıcım, size nasıl yardımcı olabilirim?',
      'İyi günler efendim, hizmetinizdeyim.',
      'Hoş geldiniz, bugün hangi konuda size destek olabilirim?',
    ],
    acknowledgments: [
      'Emredersiniz efendim.',
      'Hemen halledelim efendim.',
      'Anlaşıldı, derhal yapılıyor.',
    ],
    warnings: [
      'Efendim, yakıt seviyeniz düşük. Bir istasyona uğramanızı öneririm.',
      'Sayın kullanıcım, hızınız limiti aşıyor. Dikkatli olmanız dileğiyle.',
      'Efendim, servis zamanınız yaklaşıyor.',
    ],
    contextualResponses: {
      'hot': 'Klima sıcaklığını düşürüyorum efendim.',
      'cold': 'Evet efendim, ısıtmayı açıyorum.',
      'tired': 'Biraz dinlenmenizi önerebilir miyim? Yakında bir mola noktası var.',
      'lost': 'Endişelenmeyin efendim, doğru rotayı buluyorum.',
    },
    speechSpeed: 0.95,
    pitchLevel: 1.0,
    personality: 'formal',
  );

  static const AIPersona kanka = AIPersona(
    id: 'kanka',
    type: AIPersonaType.kanka,
    name: 'Eğlenceli Kanka',
    description: 'Samimi, şakacı ve sizinle arkadaş gibi konuşan yol arkadaşınız',
    avatarUrl: 'assets/ai_personas/kanka.png',
    voiceId: 'tr-casual-male',
    greetings: [
      'Eeey kankam! Naber, nereye gidiyoz bugün?',
      'Moruk selaaaam! Yine maceraya mı atılıyoruz?',
      'Hey dostum! Hazır mısın efsane bir yolculuğa?',
    ],
    acknowledgments: [
      'Tamam kankam, hallediyorum!',
      'Anladım moruk, yapıyorum!',
      'Hemen bakıyorum dostum!',
    ],
    warnings: [
      'Eyyy dostum! Benzin bitmek üzere ha, bir yerlere uğrayalım!',
      'Yavaşla moruk yavaşla! Hız limitini aştık biraz :)',
      'Kankam, arabayı servise götürme zamanı gelmiş!',
    ],
    contextualResponses: {
      'hot': 'Uffff sıcak ha! Klimayı açayım, serinleyelim biraz.',
      'cold': 'Brrrr üşüttün mü kankam? Hemen ısıtmayı açıyorum!',
      'tired': 'Yorgun görünüyorsun dostum, bi kahve molası verelim mi?',
      'lost': 'Kaybolmadık moruk, ben varım! Yolu buluyorum.',
    },
    speechSpeed: 1.15,
    pitchLevel: 1.1,
    personality: 'casual',
  );

  static const AIPersona koc = AIPersona(
    id: 'koc',
    type: AIPersonaType.koc,
    name: 'Sert Koç',
    description: 'Disiplinli, hedef odaklı ve sizi motive eden koçunuz',
    avatarUrl: 'assets/ai_personas/koc.png',
    voiceId: 'tr-strict-male',
    greetings: [
      'Hazır mısın? Bugün hedeflerimize ulaşacağız!',
      'Günaydın asker! Bugün ne başaracağız?',
      'Hoş geldin! Zaman değerli, hemen işe koyulalım!',
    ],
    acknowledgments: [
      'Anlaşıldı! Hemen yapılıyor!',
      'Tamam! Derhal halledicem!',
      'Alındı! Yapıyorum şimdi!',
    ],
    warnings: [
      'DİKKAT! Yakıt seviyesi kritik! Hemen istasyona!',
      'HEY! Hız limiti aşıldı! Yavaşla şimdi!',
      'UYARI! Servis zamanı geldi, erteleme!',
    ],
    contextualResponses: {
      'hot': 'Klimayı açıyorum. Ama bu sıcakta da sebat et!',
      'cold': 'Isıtmayı devreye alıyorum. Konfor önemli ama hedef daha önemli!',
      'tired': 'Yorgunluk bahane değil! Ama güvenlik öncelik, mola verelim.',
      'lost': 'Kaybolmak yok! Rotayı buluyorum, sen sadece sür!',
    },
    speechSpeed: 1.05,
    pitchLevel: 0.95,
    personality: 'strict',
  );

  /// Get all available personas
  static List<AIPersona> get allPersonas => [kahya, kanka, koc];

  /// Get persona by type
  static AIPersona getByType(AIPersonaType type) {
    return allPersonas.firstWhere((p) => p.type == type);
  }

  /// Get persona by id
  static AIPersona? getById(String id) {
    try {
      return allPersonas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a random greeting
  String getRandomGreeting() {
    return greetings[DateTime.now().millisecond % greetings.length];
  }

  /// Get a random acknowledgment
  String getRandomAcknowledgment() {
    return acknowledgments[DateTime.now().millisecond % acknowledgments.length];
  }

  /// Get contextual response
  String? getContextualResponse(String context) {
    return contextualResponses[context];
  }

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        description,
        avatarUrl,
        voiceId,
        greetings,
        acknowledgments,
        warnings,
        contextualResponses,
        speechSpeed,
        pitchLevel,
        personality,
      ];
}
