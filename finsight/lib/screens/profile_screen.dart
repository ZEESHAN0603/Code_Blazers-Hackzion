import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2), width: 4),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Shebly+S&background=0F172A&color=fff'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shebly S',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.navyDark),
            ),
            const Text(
              'Senior Portfolio Analyst',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),
            _buildOptionTile(context, Icons.security_rounded, 'Security Protocol'),
            _buildOptionTile(context, Icons.analytics_outlined, 'Export Analytics Report', onAction: () => _simulateDownloadReport(context)),
            const SizedBox(height: 20),
            _buildOptionTile(context, Icons.logout_rounded, 'Terminate Session', color: AppColors.accentRose, onAction: () => _showLogoutConfirm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String title, {Color? color, VoidCallback? onAction}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softShadow,
      ),
      child: ListTile(
        onTap: onAction ?? () {},
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppColors.accentBlue).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color ?? AppColors.accentBlue, size: 20),
        ),
        title: Text(title, style: TextStyle(color: AppColors.navyDark, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
      ),
    );
  }

  void _simulateDownloadReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Synthesizing Analytics'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.accentBlue),
            SizedBox(height: 20),
            Text('Generating comprehensive PDF...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Portfolio Report Exported Successfully'),
          backgroundColor: AppColors.accentBlue,
        ),
      );
    });
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminate Session'),
        content: const Text('Are you sure you want to logically disconnect from the dashboard?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Stay')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRose),
            child: const Text('Terminate'),
          ),
        ],
      ),
    );
  }
}
