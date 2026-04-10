import 'package:flutter/material.dart';
import '../core/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDark.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.accentBlue,
        unselectedItemColor: AppColors.textLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          _buildNavItem(Icons.grid_view_rounded, Icons.grid_view, 'Home', 0),
          _buildNavItem(Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined, 'Expenses', 1),
          _buildNavItem(Icons.layers_rounded, Icons.layers_outlined, 'Subs', 2),
          _buildNavItem(Icons.flag_rounded, Icons.flag_outlined, 'Goals', 3),
          _buildNavItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData activeIcon, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentBlue.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(isSelected ? activeIcon : icon),
      ),
      label: label,
    );
  }
}
