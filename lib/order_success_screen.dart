import 'package:flutter/material.dart';
import 'models/cart.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Clear cart after successful order
    Cart().clear();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Terima kasih telah berbelanja. Pesanan Anda sedang diproses dan akan segera dikirim.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
