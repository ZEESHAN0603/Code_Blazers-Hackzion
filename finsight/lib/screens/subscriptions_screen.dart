import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/subscription_tile.dart';
import '../widgets/glass_card.dart';
import '../models/subscription_model.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

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
              'Subscriptions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 20),
            _buildSummaryRow(data),
            const SizedBox(height: 20),
            _buildConnectButton(context),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: data.subscriptions.length,
                itemBuilder: (context, index) {
                  return SubscriptionTile(
                    subscription: data.subscriptions[index],
                    onDelete: () => data.removeSubscription(data.subscriptions[index].id),
                  );
                },
              ),
            ),
            _buildAddSubscriptionButton(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(MockDataService data) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Monthly Total', style: TextStyle(fontSize: 12, color: Colors.white60)),
                Text('₹${data.subscriptionsTotal}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Yearly Cost', style: TextStyle(fontSize: 12, color: Colors.white60)),
                Text('₹${data.subscriptionsTotal * 12}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gmail connected. Subscriptions detected.')),
          );
        },
        icon: const Icon(Icons.mail_outline_rounded),
        label: const Text('Connect Gmail'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildAddSubscriptionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: InkWell(
          onTap: () => _showAddSubscriptionDialog(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Add Subscription'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSubscriptionDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String cycle = 'monthly';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Subscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Service Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: cycle,
              items: ['monthly', 'yearly']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase())))
                  .toList(),
              onChanged: (val) => cycle = val!,
              decoration: const InputDecoration(labelText: 'Billing Cycle'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                Provider.of<MockDataService>(context, listen: false).addSubscription(
                  Subscription(
                    id: DateTime.now().toString(),
                    serviceName: nameController.text,
                    price: double.parse(priceController.text),
                    billingCycle: cycle,
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
