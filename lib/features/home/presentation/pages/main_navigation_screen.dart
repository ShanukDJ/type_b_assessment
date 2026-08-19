import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../posts/presentation/pages/dashboard_page.dart';
import '../../../posts/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppConfig appConfig;

  const MainNavigationScreen({super.key, required this.appConfig});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            appConfig: widget.appConfig,
            onProfileTap: () => _navigateToTab(4),
          ),
          _buildPlaceholderPage(
            title: AppStrings.navTopRate,
            icon: Icons.star_rounded,
            description:
                'Explore the highest rated community posts and top trending articles.',
          ),
          _buildPlaceholderPage(
            title: AppStrings.navNews,
            icon: Icons.article_rounded,
            description: 'Live world news updates and breaking tech headlines.',
          ),
          _buildPlaceholderPage(
            title: AppStrings.navChat,
            icon: Icons.chat_bubble_rounded,
            description:
                'Connect and discuss topics with fellow NewsBay readers.',
          ),
          ProfilePage(
            appConfig: widget.appConfig,
            onBack: () => _navigateToTab(0),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  Widget _buildPlaceholderPage({
    required String title,
    required IconData icon,
    required String description,
  }) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.screenTitle),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line),
                ),
                child: Icon(icon, size: 48, color: AppColors.primary1),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _navigateToTab(0),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 44),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
