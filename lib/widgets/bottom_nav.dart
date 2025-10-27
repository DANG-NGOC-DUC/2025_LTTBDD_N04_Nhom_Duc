import 'package:flutter/material.dart';
import 'package:my_app/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  static const List<String> _routes = [
    '/home',
    '/plan',
    '/reports',
    '/settings',
  ];

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    const double fabDiameter = 56.0;
    final double gapWidth = fabDiameter + 16.0;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: AppColors.primary,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // left items
            Row(
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: "Trang chủ",
                  index: 0,
                ),
                const SizedBox(width: 8),
                _buildNavItem(
                  context,
                  icon: Icons.event_note,
                  label: "Kế hoạch",
                  index: 1,
                ),
              ],
            ),

            // gap for FAB
            SizedBox(width: gapWidth),

            // right items
            Row(
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.bar_chart,
                  label: "Báo cáo",
                  index: 2,
                ),
                const SizedBox(width: 8),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: "Tài khoản",
                  index: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = index == currentIndex;
    return SizedBox(
      width: 72,
      child: InkWell(
        onTap: () => _onItemTapped(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.secondary : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.secondary : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
