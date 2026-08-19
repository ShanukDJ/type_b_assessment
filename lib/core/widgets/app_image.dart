import 'package:flutter/material.dart';

/// Reusable image widget supporting local asset rendering with optional tinting and sizing.
class AppImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final double? size;
  final Color? color;
  final BlendMode blendMode;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.size,
    this.color,
    this.blendMode = BlendMode.srcIn,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final double? effectiveWidth = size ?? width;
    final double? effectiveHeight = size ?? height;

    return Image.asset(
      assetPath,
      width: effectiveWidth,
      height: effectiveHeight,
      color: color,
      colorBlendMode: color != null ? blendMode : null,
      fit: fit,
    );
  }
}
