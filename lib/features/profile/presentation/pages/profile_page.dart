import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onBack;
  final AppConfig appConfig;

  const ProfilePage({super.key, required this.onBack, required this.appConfig});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppStrings.logoutDialogTitle,
            style: AppTextStyles.headingSmall,
          ),
          content: Text(
            AppStrings.logoutDialogMessage,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppStrings.cancel,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(const LogoutRequestedEvent());
              },
              child: Text(
                AppStrings.menuLogOut,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.critical,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppColors.primary1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(AppStrings.profileTitle, style: AppTextStyles.headingSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: onBack,
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          String fullName = 'Esther Howard';
          String initials = 'EH';
          String email = 'esther.howard@example.com';
          String? imageUrl;

          if (authState is Authenticated) {
            fullName = authState.user.fullName.isNotEmpty
                ? authState.user.fullName
                : authState.user.username;
            initials = authState.user.initials;
            email = authState.user.email;
            imageUrl = authState.user.image;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Large Avatar with camera badge
                AppAvatar(
                  initials: initials,
                  imageUrl: imageUrl,
                  radius: 54,
                  showCameraBadge: true,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.changeAvatarFeature),
                ),
                const SizedBox(height: 16),

                // Full Name
                Text(
                  fullName,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                // Email
                Text(
                  email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),

                // Environment Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.line, width: 0.8),
                  ),
                  child: Text(
                    '${AppStrings.environmentPrefix} ${appConfig.environmentName}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Menu Items matching Figma
                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: AppStrings.menuSettings,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.menuSettings),
                ),
                ProfileMenuItem(
                  icon: Icons.people_outline_rounded,
                  title: AppStrings.menuMyFriends,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.menuMyFriends),
                ),
                ProfileMenuItem(
                  icon: Icons.favorite_border_rounded,
                  title: AppStrings.menuMyFavourite,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.menuMyFavourite),
                ),
                ProfileMenuItem(
                  icon: Icons.star_outline_rounded,
                  title: AppStrings.menuLatestReviews,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.menuLatestReviews),
                ),
                ProfileMenuItem(
                  icon: Icons.rss_feed_rounded,
                  title: AppStrings.menuFollowers,
                  onTap: () =>
                      _showComingSoon(context, AppStrings.menuFollowers),
                ),
                const SizedBox(height: 16),

                // Log Out
                ProfileMenuItem(
                  icon: Icons.power_settings_new_rounded,
                  title: AppStrings.menuLogOut,
                  textColor: AppColors.critical,
                  iconColor: AppColors.critical,
                  onTap: () => _showLogoutDialog(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
