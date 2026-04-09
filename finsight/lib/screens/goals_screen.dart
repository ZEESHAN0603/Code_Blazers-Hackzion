import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/goal_card.dart';
import '../widgets/glass_card.dart';
import '../models/goal_model.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Financial Goals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: data.goals.length,
                itemBuilder: (context, index) {
                  return GoalCard(goal: data.goals[index]);
                },
              ),
            ),
            _buildAddGoalButton(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildAddGoalButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: InkWell(
          onTap: () => _showAddGoalDialog(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_task_rounded),
              SizedBox(width: 8),
              Text('Create New Goal'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Goal Name')),
            TextField(controller: targetController, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
            TextField(controller: savedController, decoration: const InputDecoration(labelText: 'Saved Amount'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && targetController.text.isNotEmpty) {
                Provider.of<MockDataService>(context, listen: false).addGoal(
                  Goal(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    targetAmount: double.parse(targetController.text),
                    savedAmount: double.tryParse(savedController.text) ?? 0,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
