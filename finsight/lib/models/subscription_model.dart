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
}
