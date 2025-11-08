import 'package:flutter/foundation.dart';

class TransactionService extends ChangeNotifier {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.add(transaction);
    notifyListeners();
    debugPrint('Transaction added: ${transaction['name']}');
    debugPrint('Total transactions: ${_transactions.length}');
  }

  void removeTransaction(int index) {
    if (index >= 0 && index < _transactions.length) {
      _transactions.removeAt(index);
      notifyListeners();
    }
  }

  void clearTransactions() {
    _transactions.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> getTransactionsByType(String type) {
    return _transactions.where((t) => t['type'] == type).toList();
  }

  List<Map<String, dynamic>> getTransactionsByCategory(String categoryKey) {
    return _transactions
        .where((t) => (t['categoryKey'] ?? t['category']) == categoryKey)
        .toList();
  }

  int getTotalAmountByType(String type) {
    return _transactions
        .where((t) => t['type'] == type)
        .fold(0, (sum, t) => sum + (t['amount'] as int));
  }

  int getTotalAmountByCategory(String categoryKey) {
    return _transactions
        .where((t) =>
            (t['categoryKey'] ?? t['category']) == categoryKey &&
            t['type'] == 'expense')
        .fold(0, (sum, t) => sum + (t['amount'] as int));
  }
}

