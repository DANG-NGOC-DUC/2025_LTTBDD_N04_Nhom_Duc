import 'package:flutter/material.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

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
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // left items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    label: 'home'.tr(),
                    index: 0,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.event_note_rounded,
                    label: 'plan'.tr(),
                    index: 1,
                  ),
                ],
              ),
            ),

            // gap reserved for FAB
            SizedBox(width: gapWidth),

            // right items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.pie_chart_rounded,
                    label: 'reports'.tr(),
                    index: 2,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person_rounded,
                    label: 'settings'.tr(),
                    index: 3,
                  ),
                ],
              ),
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
    final bool isSelected = index == currentIndex;
    final Color iconColor = isSelected ? AppColors.secondary : Colors.white70;

    return Flexible(
      child: InkWell(
        onTap: () => _onItemTapped(context, index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondary.withOpacity(0.15)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 9,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
