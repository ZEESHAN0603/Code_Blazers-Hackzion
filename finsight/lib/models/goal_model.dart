class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? targetDate;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    this.targetDate,
  });

  double get progress => savedAmount / targetAmount;
}
