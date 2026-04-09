import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/spendwise_charts.dart';
import '../core/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Navy Header Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.navyGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildAlertBanner(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(data),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Spending Categories'),
                  const SizedBox(height: 16),
                  SizedBox(height: 220, child: SpendingPieChart()),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Spending Trend'),
                  const SizedBox(height: 16),
                  SizedBox(height: 220, child: SpendingBarChart()),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Financial Diagnostics'),
                  const SizedBox(height: 16),
                  _buildDiagnosticsPanel(data),
                  const SizedBox(height: 32),
                  _buildMonthlyBudget(data),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBudget(MockDataService data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.slateBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MONTHLY BUDGET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${data.monthlySpending + 2000}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navyDark)),
              Text('₹${data.monthlySpending} Spent', style: const TextStyle(fontSize: 12, color: AppColors.accentRose)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.monthlySpending / (data.monthlySpending + 2000),
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Overview',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Welcome, Shebly',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white, letterSpacing: -0.5),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Shebly+S&background=2563EB&color=fff'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(MockDataService data) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        DashboardCard(index: 0, title: 'Total Expenses', value: '₹${data.monthlySpending.toStringAsFixed(0)}', icon: Icons.leaderboard_rounded, iconColor: AppColors.accentRose),
        DashboardCard(index: 1, title: 'Market Value', value: '₹${data.monthlySavings}', icon: Icons.token_rounded, iconColor: AppColors.accentGreen),
        DashboardCard(index: 2, title: 'Fixed Costs', value: '₹${data.subscriptionsTotal.toStringAsFixed(0)}', icon: Icons.sync_alt_rounded, iconColor: AppColors.accentBlue),
        DashboardCard(index: 3, title: 'AI Prediction', value: '₹${data.nextMonthProjection.toStringAsFixed(0)}', icon: Icons.hub_rounded, iconColor: Colors.purpleAccent),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyDark),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overspending Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(
                  'Your spending on Shopping is 25% higher than last month. Consider reviewing your non-essential purchases.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.info_outline_rounded, color: Colors.white30, size: 20),
        ],
      ),
    );
  }

  Widget _buildDiagnosticsPanel(MockDataService data) {
    return Column(
      children: [
        _buildDiagnosticCard(
          title: 'Payment Methods',
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.accentBlue,
          child: SizedBox(
            height: 120,
            child: Row(
              children: [
                const Expanded(child: PaymentMethodsChart()),
                const SizedBox(width: 20),
                _buildPaymentLegend(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildDiagnosticCard(
          title: 'Need vs Want',
          icon: Icons.compare_arrows_rounded,
          color: AppColors.accentGreen,
          child: const NeedVsWantBars(),
        ),
        const SizedBox(height: 20),
        _buildDiagnosticCard(
          title: 'Spending Moods',
          icon: Icons.mood_rounded,
          color: Colors.orange,
          child: const SpendingMoodsBars(),
        ),
      ],
    );
  }

  Widget _buildDiagnosticCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.navyDark)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildPaymentLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legendItem('UPI', AppColors.accentBlue),
        _legendItem('Wallet', AppColors.accentGreen),
        _legendItem('Credit Card', Colors.indigo),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInsightCard(int index, {required IconData icon, required Color color, required String title, required String subtitle}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          boxShadow: AppStyles.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyDark, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
