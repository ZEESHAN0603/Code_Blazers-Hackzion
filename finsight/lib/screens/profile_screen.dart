import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=shebly'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shebly S',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              'shebly@email.com',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(height: 40),
            _buildOptionTile(context, Icons.notifications_none_rounded, 'Notifications'),
            _buildOptionTile(context, Icons.privacy_tip_outlined, 'Privacy Settings'),
            _buildOptionTile(context, Icons.help_outline_rounded, 'Help Center'),
            _buildOptionTile(context, Icons.logout_rounded, 'Logout', color: Colors.redAccent),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListTile(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title tapped')),
            );
          },
          leading: Icon(icon, color: color ?? Colors.white),
          title: Text(title, style: TextStyle(color: color ?? Colors.white)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
