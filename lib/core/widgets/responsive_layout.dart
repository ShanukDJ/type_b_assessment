import 'package:flutter/material.dart';

/// Screen break-points:
/// Mobile: width < 600
/// Tablet: 600 <= width < 1024
/// Desktop: width >= 1024
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024 && desktop != null) {
      return desktop!;
    }
    if (width >= 600 && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
