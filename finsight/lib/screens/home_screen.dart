import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_card.dart';
// import '../core/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning,',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                    ),
                    const Text(
                      'Shebly',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=shebly'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard('Monthly Spending', '₹${data.monthlySpending}', Icons.trending_up, Colors.redAccent),
                _buildStatCard('Savings This Month', '₹${data.monthlySavings}', Icons.savings, Colors.greenAccent),
                _buildStatCard('Subscriptions Total', '₹${data.subscriptionsTotal}', Icons.sync, Colors.blueAccent),
                _buildStatCard('Predicted Spend', '₹${data.nextMonthProjection}', Icons.analytics, Colors.purpleAccent),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'AI Insights',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            const GlassCard(
              child: Column(
                children: [
                  InsightTile(
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orangeAccent,
                    title: 'Overspending Alert',
                    subtitle: 'Food spending increased by 18%',
                  ),
                  Divider(color: Colors.white10, height: 24),
                  InsightTile(
                    icon: Icons.lightbulb_outline_rounded,
                    color: Colors.yellowAccent,
                    title: 'AI Insight',
                    subtitle: 'You spent ₹3,200 more on restaurants this month.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for bottom navbar
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InsightTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const InsightTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
