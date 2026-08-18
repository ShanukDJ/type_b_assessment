import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const DashboardHeader({super.key, required this.onProfileTap});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String initials = 'EH';
        String? imageUrl;

        if (authState is Authenticated) {
          initials = authState.user.initials;
          imageUrl = authState.user.image;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _getGreeting(),
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppColors.onSurface,
                ),
              ),
              AppAvatar(
                initials: initials,
                imageUrl: imageUrl,
                radius: 22,
                onTap: onProfileTap,
              ),
            ],
          ),
        );
      },
    );
  }
}
