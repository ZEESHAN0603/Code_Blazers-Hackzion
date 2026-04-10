import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _url = 'YOUR_SUPABASE_URL';
  static const String _anonKey = 'YOUR_SUPABASE_ANON_KEY';
  static bool _isConfigured = false;

  static bool get isConfigured => _isConfigured;

  static Future<void> initialize() async {
    // Skip initialization if placeholder credentials are still in place.
    if (_url == 'YOUR_SUPABASE_URL' || _anonKey == 'YOUR_SUPABASE_ANON_KEY') {
      print('[SupabaseService] Skipping Supabase init: placeholder credentials detected.');
      return;
    }
    try {
      await Supabase.initialize(url: _url, anonKey: _anonKey);
      _isConfigured = true;
    } catch (e) {
      print('[SupabaseService] Initialization failed: $e');
    }
  }

  static SupabaseClient? get client => _isConfigured ? Supabase.instance.client : null;
}
