import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../core/constants.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.goal.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(GoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.progress != widget.goal.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.goal.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.goal.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyDark),
              ),
              const Icon(Icons.stars_rounded, color: AppColors.accentBlue),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: AppColors.slateBg,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${widget.goal.savedAmount.toStringAsFixed(0)} saved',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      Text(
                        '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentBlue),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
