import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _url = 'YOUR_SUPABASE_URL';
  static const String _anonKey = 'YOUR_SUPABASE_ANON_KEY';

  static Future<void> initialize() async {
    // Note: This will error if URL/Key are invalid.
    // In a real app, these should be provided.
    try {
      await Supabase.initialize(
        url: _url,
        anonKey: _anonKey,
      );
    } catch (e) {
      print('Supabase initialization failed: $e');
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
