import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import 'glass_card.dart';

class SubscriptionTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onDelete;

  const SubscriptionTile({
    super.key,
    required this.subscription,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.subscriptions_rounded, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    subscription.billingCycle.toUpperCase(),
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            Text(
              '₹${subscription.price.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
