import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guardian_angel/styles/theme.dart';

class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final double horizontalPadding;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.25 * 255).round()),
            blurRadius: 20,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 12,
        ),
        child: GNav(
          gap: 8,
          activeColor: AppColors.secondary,
          iconSize: 30,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding / 2,
            vertical: 12,
          ),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.backgroundSecondary,
          color: Colors.grey,
          tabs: const [
            GButton(icon: Icons.medication, text: 'Scheduler'),
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
        ),
      ),
    );
  }
}
