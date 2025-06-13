import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  final supabase = Supabase.instance.client;

  // Fetch all transactions
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await supabase
          .from('transactions')
          .select()
          .order('created_at', ascending: false);

      return response.map<Transaction>((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Fetch transaction details for a specific transaction
  Future<List<TransactionDetail>> getTransactionDetails(int transactionId) async {
    try {
      final response = await supabase
          .from('transaction_details')
          .select('''
            *,
            products:product_id (
              name,
              imageUrl
            )
          ''')
          .eq('transaction_id', transactionId);

      return response.map<TransactionDetail>((json) {
        // Extract product info if available
        String? productName;
        String? productImage;

        if (json['products'] != null) {
          productName = json['products']['name'];
          productImage = json['products']['imageUrl'];
        }

        return TransactionDetail.fromJson({
          ...json,
          'product_name': productName,
          'product_image': productImage,
        });
      }).toList();
    } catch (e) {
      print('Error fetching transaction details: $e');
      return [];
    }
  }

  // Fetch a transaction with its details
  Future<Transaction?> getTransactionWithDetails(int transactionId) async {
    try {
      final transactionResponse = await supabase
          .from('transactions')
          .select()
          .eq('id', transactionId)
          .single();

      final transaction = Transaction.fromJson(transactionResponse);

      // Fetch details
      final details = await getTransactionDetails(transactionId);

      return Transaction(
        id: transaction.id,
        createdAt: transaction.createdAt,
        userId: transaction.userId,
        totalAmount: transaction.totalAmount,
        latitude: transaction.latitude,
        longitude: transaction.longitude,
        address: transaction.address,
        details: details,
      );
    } catch (e) {
      print('Error fetching transaction with details: $e');
      return null;
    }
  }
}
