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
}
