import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/subscription_model.dart';
import '../models/goal_model.dart';

class MockDataService extends ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(id: '1', merchant: 'Swiggy', amount: 450, category: 'Food', date: DateTime.now(), paymentMethod: 'UPI'),
    Transaction(id: '2', merchant: 'Uber', amount: 120, category: 'Transport', date: DateTime.now(), paymentMethod: 'Card'),
    Transaction(id: '3', merchant: 'Amazon', amount: 899, category: 'Shopping', date: DateTime.now(), paymentMethod: 'Card'),
  ];

  final List<Subscription> _subscriptions = [
    Subscription(id: '1', serviceName: 'Netflix', price: 649, billingCycle: 'monthly'),
    Subscription(id: '2', serviceName: 'Spotify', price: 119, billingCycle: 'monthly'),
    Subscription(id: '3', serviceName: 'Google One', price: 130, billingCycle: 'monthly'),
  ];

  final List<Goal> _goals = [
    Goal(id: '1', name: 'Buy Laptop', targetAmount: 80000, savedAmount: 32000, targetDate: DateTime.now().add(const Duration(days: 365))),
  ];

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);
  List<Goal> get goals => List.unmodifiable(_goals);

  double get monthlySpending => _transactions.fold(0, (sum, item) => sum + item.amount);
  double get monthlySavings => 8000;
  double get subscriptionsTotal => _subscriptions.fold(0, (sum, item) => sum + item.price);
  double get nextMonthProjection => monthlySpending * 1.15;

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void addSubscription(Subscription subscription) {
    _subscriptions.insert(0, subscription);
    notifyListeners();
  }

  void removeSubscription(String id) {
    _subscriptions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void addGoal(Goal goal) {
    _goals.insert(0, goal);
    notifyListeners();
  }

  // Simulations
  Future<Transaction> simulateOCR() async {
    await Future.delayed(const Duration(seconds: 2));
    return Transaction(
      id: DateTime.now().toString(),
      merchant: 'Starbucks',
      amount: 320.0,
      category: 'Food',
      date: DateTime.now(),
      paymentMethod: 'Card',
    );
  }

  Future<List<Transaction>> simulatePDF() async {
    await Future.delayed(const Duration(seconds: 3));
    return [
      Transaction(id: 'p1', merchant: 'Zomato', amount: 560, category: 'Food', date: DateTime.now(), paymentMethod: 'UPI'),
      Transaction(id: 'p2', merchant: 'Shell', amount: 2000, category: 'Transport', date: DateTime.now(), paymentMethod: 'Card'),
    ];
  }

  Future<List<Subscription>> scanGmailForSubscriptions() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      Subscription(id: 'g1', serviceName: 'Disney+', price: 149, billingCycle: 'monthly'),
      Subscription(id: 'g2', serviceName: 'Apple Music', price: 99, billingCycle: 'monthly'),
    ];
  }
}
