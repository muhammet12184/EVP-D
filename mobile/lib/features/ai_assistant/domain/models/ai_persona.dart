enum AIPersona {
  loyalButler,    // Sadık Kâhya
  funBuddy,       // Eğlenceli Kanka
  strictCoach,    // Sert Koç
}

extension AIPersonaExtension on AIPersona {
  String get name {
    switch (this) {
      case AIPersona.loyalButler:
        return 'Sadık Kâhya';
      case AIPersona.funBuddy:
        return 'Eğlenceli Kanka';
      case AIPersona.strictCoach:
        return 'Sert Koç';
    }
  }
  
  String get description {
    switch (this) {
      case AIPersona.loyalButler:
        return 'Kibar ve resmi bir asistan';
      case AIPersona.funBuddy:
        return 'Samimi ve şakacı bir arkadaş';
      case AIPersona.strictCoach:
        return 'Disiplinli ve motive edici bir koç';
    }
  }
  
  String get greeting {
    switch (this) {
      case AIPersona.loyalButler:
        return 'Size nasıl yardımcı olabilirim, efendim?';
      case AIPersona.funBuddy:
        return 'Hey dostum! Bugün neler yapıyoruz?';
      case AIPersona.strictCoach:
        return 'Hazır mısın? Bugün hedeflerimize ulaşacağız!';
    }
  }
}
