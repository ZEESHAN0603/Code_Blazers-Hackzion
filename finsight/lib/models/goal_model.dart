class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
  });

  double get progress => savedAmount / targetAmount;
}
