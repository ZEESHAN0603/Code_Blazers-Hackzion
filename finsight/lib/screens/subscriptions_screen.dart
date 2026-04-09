import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/subscription_tile.dart';
import '../core/constants.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildCustomHeader(),
            const SizedBox(height: 10),
            _buildGmailSyncCard(context, data),
            const SizedBox(height: 10),
            _buildSubscriptionStats(data),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle('Active Subscriptions'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: data.subscriptions.length,
              itemBuilder: (context, index) {
                return SubscriptionTile(
                  subscription: data.subscriptions[index],
                  index: index,
                  onDelete: () => data.removeSubscription(data.subscriptions[index].id),
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

  Widget _buildGmailSyncCard(BuildContext context, MockDataService data) {
    final gmailController = TextEditingController();
    
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
                decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.mail_rounded, color: Colors.redAccent, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Email Sync', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navyDark)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Enter your Gmail ID to automatically discover recurring payments.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          TextField(
            controller: gmailController,
            decoration: InputDecoration(
              hintText: 'yourname@gmail.com',
              filled: true,
              fillColor: AppColors.slateBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (gmailController.text.contains('@')) {
                  _simulateGmailScan(context, data);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Extract Subscriptions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStats(MockDataService data) {
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

  void _showGmailConnect(BuildContext context, MockDataService data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Service Intelligence'),
        content: const Text('Connect your primary inbox to automatically detect recurring service invoices.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _simulateGmailScan(context, data);
            },
            child: const Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<void> _simulateGmailScan(BuildContext context, MockDataService data) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.accentBlue),
            SizedBox(height: 20),
            Text('Scanning for recurring patterns...'),
          ],
        ),
      ),
    );

    final results = await data.scanGmailForSubscriptions();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detection Complete'),
        content: Text('Found ${results.length} recurring services in your inbox.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ignore')),
          ElevatedButton(
            onPressed: () {
              for (var sub in results) { data.addSubscription(sub); }
              Navigator.pop(context);
            },
            child: const Text('Integrate All'),
          ),
        ],
      ),
    );
  }
}
