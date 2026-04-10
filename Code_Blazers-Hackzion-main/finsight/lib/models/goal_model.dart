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

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'].toString(),
      name: json['goal_name'] as String,
      targetAmount: (json['target_amount'] as num).toDouble(),
      savedAmount: (json['saved_amount'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'goal_name': name,
        'target_amount': targetAmount,
        'saved_amount': savedAmount,
      };
}
