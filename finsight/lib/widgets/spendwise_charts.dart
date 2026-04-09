import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants.dart';

class SpendingPieChart extends StatelessWidget {
  const SpendingPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(color: AppColors.accentBlue, value: 40, title: '40%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          PieChartSectionData(color: AppColors.accentGreen, value: 30, title: '30%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          PieChartSectionData(color: Colors.orangeAccent, value: 20, title: '20%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          PieChartSectionData(color: AppColors.textLight, value: 10, title: '10%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}

class SpendingBarChart extends StatefulWidget {
  const SpendingBarChart({super.key});

  @override
  State<SpendingBarChart> createState() => _SpendingBarChartState();
}

class _SpendingBarChartState extends State<SpendingBarChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barGroups: [
              _makeGroupData(0, 10 * _animation.value),
              _makeGroupData(1, 15 * _animation.value),
              _makeGroupData(2, 8 * _animation.value),
              _makeGroupData(3, 12 * _animation.value),
              _makeGroupData(4, 18 * _animation.value),
              _makeGroupData(5, 7 * _animation.value),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                    if (value.toInt() >= titles.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(titles[value.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        );
      },
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [AppColors.accentBlue, Color(0xFF60A5FA)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class PaymentMethodsChart extends StatelessWidget {
  const PaymentMethodsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(color: AppColors.accentBlue, value: 45, radius: 15, showTitle: false),
          PieChartSectionData(color: AppColors.accentGreen, value: 30, radius: 15, showTitle: false),
          PieChartSectionData(color: Colors.indigo, value: 25, radius: 15, showTitle: false),
        ],
      ),
    );
  }
}

class NeedVsWantBars extends StatelessWidget {
  const NeedVsWantBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBar('Essential', 0.8, AppColors.navyDark),
        const SizedBox(height: 12),
        _buildBar('Lifestyle', 0.3, AppColors.accentBlue),
      ],
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.slateBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class SpendingMoodsBars extends StatelessWidget {
  const SpendingMoodsBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _moodItem('Regular', 0.7, Colors.blueGrey),
        const SizedBox(height: 10),
        _moodItem('Impulse', 0.4, Colors.orange),
        const SizedBox(height: 10),
        _moodItem('Celebration', 0.2, Colors.purple),
      ],
    );
  }

  Widget _moodItem(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.slateBg,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
