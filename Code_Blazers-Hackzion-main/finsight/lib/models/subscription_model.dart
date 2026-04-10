class Subscription {
  final String id;
  final String serviceName;
  final double price;
  final String billingCycle; // 'monthly' or 'yearly'

  Subscription({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.billingCycle,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'].toString(),
      serviceName: json['service_name'] as String,
      price: (json['amount'] as num).toDouble(),
      billingCycle: json['billing_cycle'] as String? ?? 'monthly',
    );
  }

  Map<String, dynamic> toJson() => {
        'service_name': serviceName,
        'amount': price,
        'billing_cycle': billingCycle,
      };
}
