import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/finance_service.dart';
import '../widgets/subscription_tile.dart';
import '../core/constants.dart';
import '../models/subscription_model.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FinanceService>(context);

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildCustomHeader(),
            const SizedBox(height: 10),
            _buildAddSubscriptionOption(context, data),
            const SizedBox(height: 10),
            _buildSubscriptionStats(data),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle('Active Subscriptions'),
            ),
            data.subscriptions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(60),
                    child: Center(
                      child: Column(
                        children: [
                           CircularProgressIndicator(
                             color: AppColors.accentBlue,
                             strokeWidth: 3,
                           ),
                           SizedBox(height: 24),
                           Text(
                             "No subscriptions active.",
                             style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                           ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: data.subscriptions.length,
                    itemBuilder: (context, index) {
                      final sub = data.subscriptions[index];
                      return SubscriptionTile(
                        subscription: sub,
                        index: index,
                        onDelete: () => data.removeSubscription(sub.id),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Managed Services', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const Text('Subscriptions', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navyDark)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyDark));
  }

  Widget _buildAddSubscriptionOption(BuildContext context, FinanceService data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.accentBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.add_task_rounded, color: AppColors.accentBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Add Subscription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navyDark)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Track your recurring payments by adding them manually to your dashboard.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showManualAddDialog(context, data),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navyDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add Manually', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDetectDialog(context, data),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Auto Detect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showManualAddDialog(BuildContext context, FinanceService data) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String cycle = 'monthly';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Add Subscriptions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Service Name')),
                const SizedBox(height: 12),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount (₹)'), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: cycle,
                  items: const [
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  ],
                  onChanged: (v) => setState(() => cycle = v!),
                  decoration: const InputDecoration(labelText: 'Billing Cycle'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final amt = double.tryParse(amountController.text.trim()) ?? 0.0;
                  if (name.isEmpty || amt <= 0) return;
                  
                  Navigator.pop(ctx);
                  
                  try {
                    await data.addSubscription(Subscription(
                      id: '',
                      serviceName: name,
                      price: amt,
                      billingCycle: cycle,
                    ));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscription added!', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.accentGreen),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Add')
              ),
            ],
          );
        }
      ),
    );
  }

  void _showDetectDialog(BuildContext context, FinanceService data) {
    final email = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Link Account by Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to auto-detect your subscriptions.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final val = email.text.trim();
              if (val.isEmpty) return;
              
              Navigator.pop(ctx);
              
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(color: AppColors.accentBlue),
                      SizedBox(width: 20),
                      Text("Scanning inbox..."),
                    ],
                  ),
                ),
              );
              
              try {
                final subs = await data.detectSubscriptionsByEmail(val);
                if (context.mounted) {
                  Navigator.pop(context); // close loader
                  if (subs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No subscriptions found for this email.', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.accentRose),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully linked ${subs.length} subscriptions!', style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.accentGreen),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                   Navigator.pop(context);
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Error: $e')),
                   );
                }
              }
            }, 
            child: const Text('Detect')
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStats(FinanceService data) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppStyles.deepShadow,
      ),
      child: Row(
        children: [
          _buildStatBox('Monthly', '₹${data.subscriptionsTotal.toStringAsFixed(0)}'),
          Container(width: 1, height: 40, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 20)),
          _buildStatBox('Detected', '${data.subscriptions.length} Services'),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

}
