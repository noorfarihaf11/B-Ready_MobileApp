import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpResult {
  final bool success;
  final String message;
  SignUpResult({required this.success, required this.message});
}

class AuthResult {
  final bool success;
  final String message;
  AuthResult({required this.success, required this.message});
}

class AuthService {
  // ─────────────────────────────────────────────
  // 1)  Singleton setup
  // ─────────────────────────────────────────────
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;         // gunakan AuthService() di mana saja
  AuthService._internal();                   // private ctor

  // ─────────────────────────────────────────────
  // 2)  Supabase client & state
  // ─────────────────────────────────────────────
  final supabase = Supabase.instance.client;

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  // ─────────────────────────────────────────────
  // 3)  Admin check
  // ─────────────────────────────────────────────
  Future<bool> checkIsAdmin() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return _isAdmin = false;

      final response = await supabase
          .from('users')
          .select('is_admin')
          .eq('id', userId)
          .single();

      _isAdmin = response['is_admin'] ?? false;
      return _isAdmin;
    } catch (e) {
      print('Error checking admin status: $e');
      return _isAdmin = false;
    }
  }

  /// Jika Anda hanya ingin membaca ulang flag terbaru secara sinkron
  bool refreshAdminStatus() => _isAdmin;

  // ─────────────────────────────────────────────
  // 4)  Supabase auth: sign‑up
  // ─────────────────────────────────────────────
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = res.user;
      if (user == null) {
        return SignUpResult(success: false, message: 'Gagal mendaftar, user null');
      }

      // Insert data tambahan ke tabel users
      await supabase.from('users').insert({
        'id': user.id,
        'name': name,
        'email': email,
        'is_admin': false,
      });

      _isAdmin = false;
      return SignUpResult(success: true, message: 'Berhasil mendaftar');
    } on AuthException catch (e) {
      return SignUpResult(success: false, message: e.message);
    } catch (e) {
      return SignUpResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }

  // ─────────────────────────────────────────────
  // 5)  Supabase auth: sign‑in
  // ─────────────────────────────────────────────
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult(success: false, message: 'Login gagal, pengguna tidak ditemukan.');
      }

      await checkIsAdmin();                       // perbarui flag admin
      return AuthResult(success: true, message: 'Login berhasil!');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }

  // ─────────────────────────────────────────────
  // 6)  Helper: current user & sign‑out
  // ─────────────────────────────────────────────
  User? getCurrentUser() => supabase.auth.currentUser;

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _isAdmin = false; // reset flag
  }
}
