import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.line.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                label: AppStrings.navHome,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.star_rounded,
                inactiveIcon: Icons.star_outline_rounded,
                label: AppStrings.navTopRate,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.article_rounded,
                inactiveIcon: Icons.article_outlined,
                label: AppStrings.navNews,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.chat_bubble_rounded,
                inactiveIcon: Icons.chat_bubble_outline_rounded,
                label: AppStrings.navChat,
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_rounded,
                inactiveIcon: Icons.person_outline_rounded,
                label: AppStrings.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary1 : AppColors.secondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? icon : inactiveIcon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
