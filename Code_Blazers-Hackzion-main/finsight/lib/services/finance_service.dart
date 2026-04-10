import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/subscription_model.dart';
import '../models/goal_model.dart';
import 'api_service.dart';

/// Data service that manages application state by syncing with the FastAPI backend.
class FinanceService extends ChangeNotifier {
  final ApiService _api = ApiService();

  // ── Application State ──────────────────────────────────────────────────────
  List<Transaction> _transactions = [];
  List<Subscription> _subscriptions = [];
  List<Goal> _goals = [];
  Map<String, dynamic>? _dashboardData;

  // ── Getters ────────────────────────────────────────────────────────────────
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);
  List<Goal> get goals => List.unmodifiable(_goals);

  double get monthlySpending => (_dashboardData?['total_spending'] as num?)?.toDouble() ?? 0.0;
  double get monthlySavings => (_dashboardData?['goal_savings_total'] as num?)?.toDouble() ?? 0.0;
  double get subscriptionsTotal => (_dashboardData?['subscription_total'] as num?)?.toDouble() ?? 0.0;
  double get nextMonthProjection => (_dashboardData?['predicted_next_month_spending'] as num?)?.toDouble() ?? 0.0;
   int get transactionCount => (_dashboardData?['transaction_count'] as int?) ?? 0;
   String? get currentUserEmail => _api.currentUserEmail;

  // ── Initialization ─────────────────────────────────────────────────────────

  /// Load all data from the backend.
  Future<void> refreshAll() async {
    await Future.wait([
      _fetchTransactions(),
      _fetchSubscriptions(),
      _fetchGoals(),
      _fetchDashboard(),
    ]);
    notifyListeners();
  }

  Future<void> _fetchTransactions() async {
    try {
      final raw = await _api.getTransactions();
      _transactions = raw.map((j) => Transaction.fromJson(j)).toList();
    } catch (e) {
      debugPrint('[FinanceService] fetchTransactions error: $e');
    }
  }

   Future<void> _fetchSubscriptions() async {
     try {
       final raw = await _api.getSubscriptions(email: _api.currentUserEmail);
       _subscriptions = raw.map((j) => Subscription.fromJson(j)).toList();
     } catch (e) {
       debugPrint('[FinanceService] fetchSubscriptions error: $e');
     }
   }
 
  Future<List<Subscription>> detectSubscriptionsByEmail(String email) async {
    try {
      final raw = await _api.detectSubscriptionsByEmail(email);
      final newSubs = raw.map((j) => Subscription.fromJson(j)).toList();
      await refreshAll();
      return newSubs;
    } catch (e) {
      debugPrint('[FinanceService] detect error: $e');
      rethrow;
    }
  }

  Future<void> _fetchGoals() async {
    try {
      final raw = await _api.getGoals();
      _goals = raw.map((j) => Goal.fromJson(j)).toList();
    } catch (e) {
      debugPrint('[FinanceService] fetchGoals error: $e');
    }
  }

  Future<void> _fetchDashboard() async {
    try {
      _dashboardData = await _api.getDashboard();
    } catch (e) {
      debugPrint('[FinanceService] fetchDashboard error: $e');
    }
  }

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _api.login(email, password);
    await refreshAll();
    return res as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> signup(String email, String password, {String? fullName}) async {
    final res = await _api.signup(email, password, fullName: fullName);
    await refreshAll();
    return res as Map<String, dynamic>;
  }

  void logout() {
    _api.logout();
    _transactions = [];
    _subscriptions = [];
    _goals = [];
    _dashboardData = null;
    notifyListeners();
  }

  // ── CRUD Operations ────────────────────────────────────────────────────────

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _api.createTransaction(
        merchant: transaction.merchant,
        amount: transaction.amount,
        category: transaction.category,
        date: transaction.date.toIso8601String().split('T').first,
        paymentMethod: transaction.paymentMethod,
      );
      await refreshAll(); // Refresh to get server-side analysis
    } catch (e) {
      debugPrint('[FinanceService] addTransaction error: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _api.deleteTransaction(id);
      await refreshAll();
    } catch (e) {
      debugPrint('[FinanceService] deleteTransaction error: $e');
      rethrow;
    }
  }

  Future<void> addSubscription(Subscription subscription) async {
    try {
      await _api.createSubscription(
        serviceName: subscription.serviceName,
        amount: subscription.price,
        billingCycle: subscription.billingCycle,
      );
      await refreshAll();
    } catch (e) {
      debugPrint('[FinanceService] addSubscription error: $e');
      rethrow;
    }
  }

  Future<void> removeSubscription(String id) async {
    try {
      await _api.deleteSubscription(id);
      await refreshAll();
    } catch (e) {
      debugPrint('[FinanceService] deleteSubscription error: $e');
      rethrow;
    }
  }

  Future<void> addGoal(Goal goal) async {
    try {
      await _api.createGoal(
        goalName: goal.name,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount,
      );
      await refreshAll();
    } catch (e) {
      debugPrint('[FinanceService] addGoal error: $e');
      rethrow;
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _api.deleteGoal(id);
      await refreshAll();
    } catch (e) {
      debugPrint('[FinanceService] deleteGoal error: $e');
      rethrow;
    }
  }
}
