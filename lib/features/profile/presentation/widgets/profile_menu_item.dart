import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showChevron;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? AppColors.onSurface;
    final effectiveIconColor = iconColor ?? AppColors.secondary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: effectiveIconColor),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: effectiveTextColor,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.secondary,
              ),
          ],
        ),
      ),
    );
  }
}
