import 'dart:async';
import '../../../core/models/wallet_model.dart';

/// Wallet Service - Handles all payment and financial operations
class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  Wallet? _wallet;
  
  final StreamController<Wallet> _walletController = 
      StreamController<Wallet>.broadcast();

  Stream<Wallet> get walletStream => _walletController.stream;
  Wallet? get wallet => _wallet;

  /// Initialize wallet service
  Future<void> initialize(String userId) async {
    // Load wallet from storage or API
    await _loadWallet(userId);
  }

  /// Load wallet data
  Future<void> _loadWallet(String userId) async {
    // TODO: Load from API
    // For now, create a mock wallet
    _wallet = Wallet(
      id: 'wallet_$userId',
      userId: userId,
      balance: 500.0,
      currency: 'TRY',
      cards: [],
      recentTransactions: [],
      lastUpdated: DateTime.now(),
    );
    
    _walletController.add(_wallet!);
  }

  /// Add payment card
  Future<void> addCard(PaymentCard card) async {
    if (_wallet == null) return;

    final cards = List<PaymentCard>.from(_wallet!.cards);
    cards.add(card);

    _wallet = _wallet!.copyWith(
      cards: cards,
      lastUpdated: DateTime.now(),
    );
    
    _walletController.add(_wallet!);
    
    // TODO: Save to API
  }

  /// Remove payment card
  Future<void> removeCard(String cardId) async {
    if (_wallet == null) return;

    final cards = _wallet!.cards.where((c) => c.id != cardId).toList();

    _wallet = _wallet!.copyWith(
      cards: cards,
      lastUpdated: DateTime.now(),
    );
    
    _walletController.add(_wallet!);
    
    // TODO: Save to API
  }

  /// Process payment
  Future<Transaction> processPayment({
    required TransactionType type,
    required double amount,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    if (_wallet == null) {
      throw Exception('Wallet not initialized');
    }

    final transaction = Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: _wallet!.userId,
      type: type,
      amount: amount,
      currency: _wallet!.currency,
      status: PaymentStatus.pending,
      description: description,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    // Process payment (integrate with payment gateway)
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing

    // Update transaction status
    final completedTransaction = Transaction(
      id: transaction.id,
      userId: transaction.userId,
      type: transaction.type,
      amount: transaction.amount,
      currency: transaction.currency,
      status: PaymentStatus.completed,
      description: transaction.description,
      timestamp: transaction.timestamp,
      metadata: transaction.metadata,
    );

    // Update wallet balance
    final newBalance = _wallet!.balance - amount;
    final transactions = [completedTransaction, ..._wallet!.recentTransactions];

    _wallet = _wallet!.copyWith(
      balance: newBalance,
      recentTransactions: transactions.take(20).toList(),
      lastUpdated: DateTime.now(),
    );
    
    _walletController.add(_wallet!);

    // TODO: Save to API

    return completedTransaction;
  }

  /// Add funds to wallet
  Future<void> addFunds(double amount) async {
    if (_wallet == null) return;

    final transaction = Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: _wallet!.userId,
      type: TransactionType.other,
      amount: amount,
      currency: _wallet!.currency,
      status: PaymentStatus.completed,
      description: 'Cüzdana para eklendi',
      timestamp: DateTime.now(),
    );

    final newBalance = _wallet!.balance + amount;
    final transactions = [transaction, ..._wallet!.recentTransactions];

    _wallet = _wallet!.copyWith(
      balance: newBalance,
      recentTransactions: transactions.take(20).toList(),
      lastUpdated: DateTime.now(),
    );
    
    _walletController.add(_wallet!);

    // TODO: Save to API
  }

  /// Pay for insurance
  Future<Transaction> payInsurance({
    required String vehicleId,
    required double amount,
    required String insuranceCompany,
  }) async {
    return await processPayment(
      type: TransactionType.insurance,
      amount: amount,
      description: 'Araç Sigortası - $insuranceCompany',
      metadata: {
        'vehicleId': vehicleId,
        'company': insuranceCompany,
      },
    );
  }

  /// Pay MTV (Motor Vehicle Tax)
  Future<Transaction> payMTV({
    required String vehicleId,
    required double amount,
  }) async {
    return await processPayment(
      type: TransactionType.mtv,
      amount: amount,
      description: 'Motorlu Taşıtlar Vergisi',
      metadata: {
        'vehicleId': vehicleId,
      },
    );
  }

  /// Pay for charging
  Future<Transaction> payCharging({
    required String vehicleId,
    required String stationId,
    required double amount,
    required double energyKwh,
  }) async {
    return await processPayment(
      type: TransactionType.charging,
      amount: amount,
      description: 'Elektrik Şarj - ${energyKwh.toStringAsFixed(1)} kWh',
      metadata: {
        'vehicleId': vehicleId,
        'stationId': stationId,
        'energyKwh': energyKwh,
      },
    );
  }

  /// Pay for fuel
  Future<Transaction> payFuel({
    required String vehicleId,
    required String stationName,
    required double amount,
    required double liters,
  }) async {
    return await processPayment(
      type: TransactionType.fuel,
      amount: amount,
      description: 'Yakıt - $stationName (${liters.toStringAsFixed(1)}L)',
      metadata: {
        'vehicleId': vehicleId,
        'stationName': stationName,
        'liters': liters,
      },
    );
  }

  /// Pay for parking
  Future<Transaction> payParking({
    required double amount,
    required String location,
    required Duration duration,
  }) async {
    return await processPayment(
      type: TransactionType.parking,
      amount: amount,
      description: 'Park - $location',
      metadata: {
        'location': location,
        'durationMinutes': duration.inMinutes,
      },
    );
  }

  /// Pay at Drive-Thru
  Future<Transaction> payDriveThru({
    required double amount,
    required String merchantName,
  }) async {
    return await processPayment(
      type: TransactionType.driveThru,
      amount: amount,
      description: 'Drive-Thru - $merchantName',
      metadata: {
        'merchantName': merchantName,
      },
    );
  }

  /// Process P2P rental payment
  Future<Transaction> payRental({
    required String vehicleId,
    required String ownerId,
    required double amount,
    required Duration duration,
  }) async {
    return await processPayment(
      type: TransactionType.rental,
      amount: amount,
      description: 'Araç Kiralama - ${duration.inHours} saat',
      metadata: {
        'vehicleId': vehicleId,
        'ownerId': ownerId,
        'durationHours': duration.inHours,
      },
    );
  }

  /// Get transaction history
  Future<List<Transaction>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) async {
    if (_wallet == null) return [];

    var transactions = _wallet!.recentTransactions;

    if (startDate != null) {
      transactions = transactions.where((t) => 
        t.timestamp.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      transactions = transactions.where((t) => 
        t.timestamp.isBefore(endDate)).toList();
    }

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    return transactions;
  }

  /// Calculate monthly spending by category
  Map<TransactionType, double> getMonthlySpendingByCategory() {
    if (_wallet == null) return {};

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final monthlyTransactions = _wallet!.recentTransactions.where((t) => 
      t.timestamp.isAfter(startOfMonth) && 
      t.status == PaymentStatus.completed
    );

    final Map<TransactionType, double> spending = {};

    for (var transaction in monthlyTransactions) {
      spending[transaction.type] = 
        (spending[transaction.type] ?? 0) + transaction.amount;
    }

    return spending;
  }

  /// Dispose resources
  void dispose() {
    _walletController.close();
  }
}
