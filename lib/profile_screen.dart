import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // User information
                TextFormField(
                  initialValue: _user.name,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    _user.name = value;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _user.email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _user.email = value;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _user.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    _user.phone = value;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _user.address,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    _user.address = value;
                  },
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil berhasil disimpan'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Simpan Profil',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Order history section
                const Divider(),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Riwayat Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Empty order history
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Belum ada riwayat pesanan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
