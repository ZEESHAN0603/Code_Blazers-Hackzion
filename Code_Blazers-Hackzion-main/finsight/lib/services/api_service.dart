import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Central service for all HTTP calls to the FinSight FastAPI backend.
class ApiService {
  // ── Configuration ─────────────────────────────────────────────────────────
  
  // Use 10.0.2.2 on Android emulator. For Chrome/Web/iPhone, use localhost.
  // In a real app, this would be an environment variable.
  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    // For Android Emulator, we'd typically check Platform.isAndroid
    // but since this is a general web/mobile choice:
    return 'http://localhost:8000'; 
  }

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

   final http.Client _client = http.Client();
   String? _authToken;
   String? _currentUserEmail;
 
   // ── Auth State ────────────────────────────────────────────────────────────
   
   void setToken(String token) => _authToken = token;
   void logout() {
     _authToken = null;
     _currentUserEmail = null;
   }
   bool get isAuthenticated => _authToken != null;
   String? get currentUserEmail => _currentUserEmail;

  // ── Helpers ────────────────────────────────────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Future<dynamic> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(uri, headers: _headers).timeout(
      const Duration(seconds: 15),
    );
    return _handleResponse(response);
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client
        .post(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 120));
    return _handleResponse(response);
  }

  Future<dynamic> _put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client
        .put(uri, headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response);
  }

  Future<dynamic> _delete(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client
        .delete(uri, headers: _headers)
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw ApiException(response.statusCode, response.body);
  }

  // ── Auth ──────────────────────────────────────────────────────────────────

   Future<Map<String, dynamic>> signup(String email, String password, {String? fullName}) async {
     final res = await _post('/auth/signup', {
       'email': email,
       'password': password,
       if (fullName != null) 'full_name': fullName,
     });
     if (res['access_token'] != 'verification_email_sent') {
       _authToken = res['access_token'];
       _currentUserEmail = email; // Store email
     }
     return res;
   }
 
   Future<Map<String, dynamic>> login(String email, String password) async {
     final res = await _post('/auth/login', {
       'email': email,
       'password': password,
     });
     _authToken = res['access_token'];
     _currentUserEmail = email; // Store email
     return res;
   }

  // ── Health / Dashboard ─────────────────────────────────────────────────────

  Future<bool> isHealthy() async {
    try {
      final uri = Uri.parse('$_baseUrl/');
      final res = await _client.get(uri).timeout(const Duration(seconds: 2));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getDashboard() async {
    return await _get('/dashboard');
  }

  // ── Transactions ───────────────────────────────────────────────────────────

  Future<List<dynamic>> getTransactions({int skip = 0, int limit = 100}) async {
    return await _get('/transactions/?skip=$skip&limit=$limit');
  }

  Future<Map<String, dynamic>> createTransaction({
    required String merchant,
    required double amount,
    required String category,
    required String date,
    String? paymentMethod,
  }) async {
    return await _post('/transactions/', {
      'merchant': merchant,
      'amount': amount,
      'category': category,
      'date': date,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _delete('/transactions/$id');
  }

  // ── Subscriptions ──────────────────────────────────────────────────────────

   Future<List<dynamic>> getSubscriptions({String? email}) async {
     final path = email != null ? '/subscriptions/?email=$email' : '/subscriptions/';
     return await _get(path);
   }

  Future<List<dynamic>> detectSubscriptionsByEmail(String email) async {
    return await _post('/subscriptions/detect', {'email': email});
  }

  Future<Map<String, dynamic>> createSubscription({
    required String serviceName,
    required double amount,
    required String billingCycle,
  }) async {
    return await _post('/subscriptions/', {
      'service_name': serviceName,
      'amount': amount,
      'billing_cycle': billingCycle,
    });
  }

  Future<void> deleteSubscription(String id) async {
    await _delete('/subscriptions/$id');
  }

  // ── Goals ──────────────────────────────────────────────────────────────────

  Future<List<dynamic>> getGoals() async {
    return await _get('/goals/');
  }

  Future<Map<String, dynamic>> createGoal({
    required String goalName,
    required double targetAmount,
    double savedAmount = 0,
  }) async {
    return await _post('/goals/', {
      'goal_name': goalName,
      'target_amount': targetAmount,
      'saved_amount': savedAmount,
    });
  }

  Future<void> deleteGoal(String id) async {
    await _delete('/goals/$id');
  }

  // ── AI Chat ────────────────────────────────────────────────────────────────

  Future<String> sendChatMessage(String message) async {
    final result = await _post('/ai-chat', {'user_message': message});
    return result['response'] as String;
  }

  // ── OCR Receipt ───────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> scanReceipt(List<int> imageBytes, String filename) async {
    final uri = Uri.parse('$_baseUrl/scan-receipt/');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ));

    final streamedResponse = await request.send().timeout(const Duration(seconds: 120));
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response) as Map<String, dynamic>;
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}
