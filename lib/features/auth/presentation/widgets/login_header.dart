import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 308,
      decoration: const BoxDecoration(gradient: AppColors.loginHeaderGradient),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.article_rounded,
                  size: 40,
                  color: AppColors.white,
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
