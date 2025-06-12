import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Roti', 'Kue', 'Donat'];

  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final List data = await Supabase.instance.client
          .from('products')
          .select();

      print('Fetched products: $data');

      setState(() {
        _products = data.map((item) => Product.fromMap(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      setState(() => _isLoading = false);
    }
  }


  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Semua') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakery App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kue atau roti...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategory == _categories[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Product grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final List<dynamic> data = await Supabase.instance.client
          .from('products')
          .select();

      return data.map((item) => Product.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Fetch error: $e');
      throw Exception('Gagal mengambil produk');
    }
  }


  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
