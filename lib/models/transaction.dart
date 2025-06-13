double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

class Transaction {
  final int id;
  final DateTime createdAt;
  final String userId;
  final double totalAmount;
  final double latitude;
  final double longitude;
  final String address;
  final List<TransactionDetail> details;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.totalAmount,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.details = const [],
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      totalAmount: json['total_amount'] is int
          ? (json['total_amount'] as int).toDouble()
          : json['total_amount'],
      latitude: json['latitude'] is int
          ? (json['latitude'] as int).toDouble()
          : json['latitude'],
      longitude: json['longitude'] is int
          ? (json['longitude'] as int).toDouble()
          : json['longitude'],
      address: json['address'] ?? '',
      details: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'total_amount': totalAmount,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class TransactionDetail {
  final int id;
  final int transactionId;
  final int productId;
  final double price;
  final double subtotal;
  final DateTime createdAt;
  final int quantity;

  // Optional product info for display
  final String? productName;
  final String? productImage;

  TransactionDetail({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.price,
    required this.subtotal,
    required this.createdAt,
    required this.quantity,
    this.productName,
    this.productImage,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'],
      transactionId: json['transaction_id'],
      productId: json['product_id'],
        price: _toDouble(json['price']),       // ← Gunakan helper di sini
        subtotal: _toDouble(json['subtotal']),
      createdAt: DateTime.parse(json['created_at']),
      quantity: json['quantity'],
      productName: json['product_name'],
      productImage: json['product_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'product_id': productId,
      'price': price,
      'subtotal': subtotal,
      'created_at': createdAt.toIso8601String(),
      'quantity': quantity,
    };
  }
}
