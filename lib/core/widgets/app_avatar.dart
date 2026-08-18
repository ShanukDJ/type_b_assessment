import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final VoidCallback? onTap;
  final bool showCameraBadge;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.radius = 22,
    this.onTap,
    this.showCameraBadge = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = backgroundColor ?? AppColors.primary1;

    final avatarWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: effectiveColor,
            boxShadow: [
              BoxShadow(
                color: effectiveColor.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials.isNotEmpty ? initials.toUpperCase() : 'NB',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.white,
                fontSize: radius * 0.75,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        if (showCameraBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF6C6C78),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 14,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatarWidget);
    }
    return avatarWidget;
  }
}
