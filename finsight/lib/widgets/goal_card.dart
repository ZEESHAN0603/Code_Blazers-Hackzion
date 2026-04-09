import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import 'glass_card.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Icon(Icons.flag_rounded, color: Colors.white.withOpacity(0.8)),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${goal.savedAmount.toStringAsFixed(0)} saved',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
                Text(
                  'Target: ₹${goal.targetAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
