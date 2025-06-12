import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'main.dart'; // ini untuk akses MainScreen kamu

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const LoginPage(); // belum login
    } else {
      return const MainScreen(); // sudah login, masuk ke home navigasi
    }
  }
}
