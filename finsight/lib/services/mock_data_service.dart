import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/subscription_model.dart';
import '../models/goal_model.dart';

class MockDataService extends ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(id: '1', merchant: 'Swiggy', amount: 450, category: 'Food', date: DateTime.now()),
    Transaction(id: '2', merchant: 'Uber', amount: 120, category: 'Transport', date: DateTime.now()),
    Transaction(id: '3', merchant: 'Amazon', amount: 899, category: 'Shopping', date: DateTime.now()),
  ];

  final List<Subscription> _subscriptions = [
    Subscription(id: '1', serviceName: 'Netflix', price: 649, billingCycle: 'monthly'),
    Subscription(id: '2', serviceName: 'Spotify', price: 119, billingCycle: 'monthly'),
    Subscription(id: '3', serviceName: 'Google One', price: 130, billingCycle: 'monthly'),
  ];

  final List<Goal> _goals = [
    Goal(id: '1', name: 'Buy Laptop', targetAmount: 80000, savedAmount: 32000),
  ];

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);
  List<Goal> get goals => List.unmodifiable(_goals);

  // Home Screen Stats
  double get monthlySpending => _transactions.fold(0, (sum, item) => sum + item.amount);
  double get monthlySavings => 8000;
  double get subscriptionsTotal => _subscriptions.fold(0, (sum, item) => sum + item.price);
  double get nextMonthProjection => 41000;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    notifyListeners();
  }

  void removeSubscription(String id) {
    _subscriptions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }
}
