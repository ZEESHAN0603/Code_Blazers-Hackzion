class Transaction {
  final String id;
  final String merchant;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod; // 'Card', 'UPI', 'Cash'

  Transaction({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.date,
    this.paymentMethod = 'UPI',
  });

  /// Create from FastAPI JSON response (id is int on backend, cast to String)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      merchant: json['merchant'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      paymentMethod: json['payment_method'] as String? ?? 'UPI',
    );
  }

  Map<String, dynamic> toJson() => {
        'merchant': merchant,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String().split('T').first,
        'payment_method': paymentMethod,
      };
}
