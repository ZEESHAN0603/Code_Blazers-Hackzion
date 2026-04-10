import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/finance_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _smsAccessEnabled = false;

  void _toggleSmsAccess(bool value) {
    if (value) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Security Protocol'),
          content: const Text('Allow app to read SMS?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Deny')
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _smsAccessEnabled = true);
                Navigator.pop(ctx);
              }, 
              child: const Text('Allow')
            )
          ],
        )
      );
    } else {
      setState(() => _smsAccessEnabled = false);
    }
  }

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
            _buildOptionTile(
              context, 
              Icons.security_rounded, 
              'Enable SMS Access', 
              onAction: () => _toggleSmsAccess(!_smsAccessEnabled),
              customTrailing: Switch(
                value: _smsAccessEnabled,
                onChanged: (v) => _toggleSmsAccess(v),
                activeColor: AppColors.accentBlue,
              )
            ),
            _buildOptionTile(context, Icons.analytics_outlined, 'Export Statement', onAction: () => _simulateDownloadReport(context)),
            const SizedBox(height: 20),
            _buildOptionTile(context, Icons.logout_rounded, 'Terminate Session', color: AppColors.accentRose, onAction: () => _showLogoutConfirm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String title, {Color? color, VoidCallback? onAction, Widget? customTrailing}) {
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
        trailing: customTrailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
      ),
    );
  }

  void _simulateDownloadReport(BuildContext context) {
    // Check account age mock constraint
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Unavailable'),
        content: const Text('You can export statement only after 1 month of usage.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Understood')
          )
        ],
      )
    );
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
              Provider.of<FinanceService>(context, listen: false).logout();
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
