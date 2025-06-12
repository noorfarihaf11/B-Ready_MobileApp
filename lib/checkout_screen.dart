import 'package:flutter/material.dart';
import 'models/cart.dart';
import '../models/user.dart';
import 'order_success_screen.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  final _cart = Cart();
  bool _isLoading = false;

  // Mock function to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate getting location
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Mock location (Jakarta coordinates)
      _user.latitude = -6.2088;
      _user.longitude = 106.8456;
      _isLoading = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi berhasil didapatkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Items
                        ...List.generate(_cart.items.length, (index) {
                          final item = _cart.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.quantity}x ${item.product.name}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Rp ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }),

                        const Divider(),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rp ${_cart.totalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Customer information
                const Text(
                  'Informasi Pelanggan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _user.name = value;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _user.phone = value;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Alamat Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _user.address = value;
                  },
                ),
                const SizedBox(height: 24),

                // Location
                const Text(
                  'Lokasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kami membutuhkan lokasi Anda untuk pengiriman',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Location button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    icon: const Icon(Icons.location_on),
                    label: _isLoading
                        ? const Text('Mendapatkan lokasi...')
                        : const Text('Dapatkan Lokasi Saat Ini'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                // Show coordinates if available
                if (_user.latitude != null && _user.longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Koordinat: ${_user.latitude}, ${_user.longitude}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),

                const SizedBox(height: 32),

                // Place order button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_user.latitude == null || _user.longitude == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mohon dapatkan lokasi Anda terlebih dahulu'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Process order
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderSuccessPage(),
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
                      'Pesan Sekarang',
                      style: TextStyle(fontSize: 16),
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
