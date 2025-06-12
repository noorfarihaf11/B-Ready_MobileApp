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
  final supabase = Supabase.instance.client;

  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user != null) {
        // Masukkan data tambahan ke tabel users
        await supabase.from('users').insert({
          'id': user.id, // Ini ID dari auth
          'name': name,
          'email': email,
          'is_admin': false, // default false
        });

        return SignUpResult(success: true, message: 'Berhasil mendaftar');
      } else {
        return SignUpResult(success: false, message: 'Gagal mendaftar, user null');
      }
    } on AuthException catch (e) {
      return SignUpResult(success: false, message: e.message);
    } catch (e) {
      return SignUpResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }


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

      return AuthResult(success: true, message: 'Login berhasil!');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }
}
