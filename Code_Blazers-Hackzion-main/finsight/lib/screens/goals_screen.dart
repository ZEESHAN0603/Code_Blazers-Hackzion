import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/finance_service.dart';
import '../widgets/goal_card.dart';
import '../core/constants.dart';
import '../models/goal_model.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FinanceService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategic Goals'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: data.goals.length,
        itemBuilder: (context, index) {
          return GoalCard(goal: data.goals[index]);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context, data),
        backgroundColor: AppColors.accentBlue,
        label: const Text('Create New Goal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, FinanceService data) {
    final name = TextEditingController();
    final target = TextEditingController();
    final saved = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Goal Configuration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Goal Target')),
            const SizedBox(height: 12),
            TextField(controller: target, decoration: const InputDecoration(labelText: 'Financial Target'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: saved, decoration: const InputDecoration(labelText: 'Starting Balance'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (name.text.isNotEmpty && target.text.isNotEmpty) {
                await data.addGoal(Goal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name.text,
                  targetAmount: double.parse(target.text),
                  savedAmount: double.tryParse(saved.text) ?? 0,
                ));
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }
}
