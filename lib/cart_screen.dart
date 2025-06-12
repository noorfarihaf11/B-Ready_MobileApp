import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'checkout_screen.dart';
import 'signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _cart.items.isEmpty
          ? _buildEmptyCart()
          : _buildCartItems(),
      bottomNavigationBar: _cart.items.isEmpty
          ? null
          : _buildCheckoutButton(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Keranjang belanja Anda kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan beberapa produk untuk melanjutkan',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cart.items.length,
            itemBuilder: (context, index) {
              final item = _cart.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // First row: Image and product details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.product.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${item.product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Second row: Quantity controls and delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity text
                          const Text(
                            'Jumlah:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Quantity controls
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    _cart.updateQuantity(item.product.id, item.quantity - 1);
                                  });
                                },
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    _cart.updateQuantity(item.product.id, item.quantity + 1);
                                  });
                                },
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),

                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _cart.removeItem(item.product.id);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Order summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              top: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
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
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          final user = Supabase.instance.client.auth.currentUser;

          if (user == null) {
            // Belum login → arahkan ke halaman sign up
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpPage(),
              ),
            );
          } else {
            // Sudah login → lanjut ke checkout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckoutPage(),
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
          'Lanjutkan ke Pembayaran',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
