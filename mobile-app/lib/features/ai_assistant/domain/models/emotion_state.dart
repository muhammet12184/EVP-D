enum EmotionType {
  calm,
  stressed,
  happy,
  tired,
  focused,
  distracted,
}

class EmotionState {
  final EmotionType type;
  final double intensity; // 0.0 - 1.0
  final DateTime detectedAt;
  
  const EmotionState({
    required this.type,
    required this.intensity,
    required this.detectedAt,
  });
  
  String get description {
    switch (type) {
      case EmotionType.stressed:
        return 'Stres seviyeniz yüksek görünüyor. Rahatlatıcı müzik açalım mı?';
      case EmotionType.tired:
        return 'Yorgun görünüyorsunuz. Yakınlarda bir mola yeri önerebilirim.';
      case EmotionType.happy:
        return 'Harika bir gün geçiriyorsunuz! 🎉';
      default:
        return '';
    }
  }
}
