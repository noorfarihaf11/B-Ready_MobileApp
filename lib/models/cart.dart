import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class Cart {
  static final Cart _instance = Cart._internal();

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  final List<CartItem> items = [];

  void addItem(Product product) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      items[existingIndex].quantity += 1;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeItem(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int quantity) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      items[index].quantity = quantity;
      if (items[index].quantity <= 0) {
        removeItem(productId);
      }
    }
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void clear() {
    items.clear();
  }
}
