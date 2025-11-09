import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Replace with your actual Supabase credentials
  static const String supabaseUrl = 'https://fztptgahiutcxgvpoayx.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6dHB0Z2FoaXV0Y3hndnBvYXl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2MDgwNTEsImV4cCI6MjA3ODE4NDA1MX0.ClR_epx7sL8sFuYghVbHAeEqUygwhihALLASwKhUNhE';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Helper method to check if user is logged in
  static bool get isLoggedIn => client.auth.currentUser != null;

  // Helper method to get current user
  static User? get currentUser => client.auth.currentUser;

  // Helper method to sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
}
