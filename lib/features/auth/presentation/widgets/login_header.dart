import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.36,
      decoration: const BoxDecoration(gradient: AppColors.loginHeaderGradient),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.article_rounded,
                    size: 38,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(AppStrings.appName, style: AppTextStyles.logoText),
            ],
          ),
        ),
      ),
    );
  }
}
