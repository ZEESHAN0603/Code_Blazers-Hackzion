import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../core/constants.dart';

class SubscriptionTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onDelete;
  final int index;

  const SubscriptionTile({
    super.key,
    required this.subscription,
    required this.onDelete,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                color: AppColors.accentBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.subscriptions_rounded, color: AppColors.accentBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navyDark),
                  ),
                  Text(
                    subscription.billingCycle.toUpperCase(),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            Text(
              '₹${subscription.price.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.accentBlue),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.accentRose.withValues(alpha: 0.7), size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
