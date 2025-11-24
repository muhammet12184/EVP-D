import 'package:equatable/equatable.dart';

enum TransactionType {
  insurance, // Sigorta
  mtv, // Motorlu Taşıtlar Vergisi
  hgs, // HGS/OGS Geçiş
  charging, // Elektrik şarj
  fuel, // Yakıt
  parking, // Park
  driveThru, // Drive-Thru
  rental, // Araç kiralama
  maintenance, // Bakım/Servis
  reward, // Ödül/Kazanç
  other, // Diğer
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

/// Super Wallet Model
class Wallet extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final List<PaymentCard> cards;
  final List<Transaction> recentTransactions;
  final DateTime? lastUpdated;

  const Wallet({
    required this.id,
    required this.userId,
    this.balance = 0.0,
    this.currency = 'TRY',
    this.cards = const [],
    this.recentTransactions = const [],
    this.lastUpdated,
  });

  Wallet copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    List<PaymentCard>? cards,
    List<Transaction>? recentTransactions,
    DateTime? lastUpdated,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      cards: cards ?? this.cards,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'cards': cards.map((c) => c.toJson()).toList(),
      'recentTransactions': recentTransactions.map((t) => t.toJson()).toList(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'TRY',
      cards: (json['cards'] as List<dynamic>?)
              ?.map((c) => PaymentCard.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((t) => Transaction.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        balance,
        currency,
        cards,
        recentTransactions,
        lastUpdated,
      ];
}

/// Payment Card Model
class PaymentCard extends Equatable {
  final String id;
  final String cardHolderName;
  final String cardNumberMasked; // **** **** **** 1234
  final String expiryMonth;
  final String expiryYear;
  final String cardType; // visa, mastercard, etc.
  final bool isDefault;

  const PaymentCard({
    required this.id,
    required this.cardHolderName,
    required this.cardNumberMasked,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardType,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'cardNumberMasked': cardNumberMasked,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardType': cardType,
      'isDefault': isDefault,
    };
  }

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] as String,
      cardHolderName: json['cardHolderName'] as String,
      cardNumberMasked: json['cardNumberMasked'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      cardType: json['cardType'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cardHolderName,
        cardNumberMasked,
        expiryMonth,
        expiryYear,
        cardType,
        isDefault,
      ];
}

/// Transaction Model
class Transaction extends Equatable {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'TRY',
    required this.status,
    required this.description,
    required this.timestamp,
    this.metadata,
  });

  String get typeDisplayName {
    switch (type) {
      case TransactionType.insurance:
        return 'Sigorta';
      case TransactionType.mtv:
        return 'MTV';
      case TransactionType.hgs:
        return 'HGS/OGS';
      case TransactionType.charging:
        return 'Şarj';
      case TransactionType.fuel:
        return 'Yakıt';
      case TransactionType.parking:
        return 'Park';
      case TransactionType.driveThru:
        return 'Drive-Thru';
      case TransactionType.rental:
        return 'Kiralama';
      case TransactionType.maintenance:
        return 'Bakım';
      case TransactionType.reward:
        return 'Ödül';
      case TransactionType.other:
        return 'Diğer';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'TRY',
      status: PaymentStatus.values.firstWhere((e) => e.name == json['status']),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        amount,
        currency,
        status,
        description,
        timestamp,
        metadata,
      ];
}
