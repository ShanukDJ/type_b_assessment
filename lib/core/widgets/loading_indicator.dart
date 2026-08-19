import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 28,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary1,
          ),
        ),
      ),
    );
  }
}

/// Animated shimmer wrapper widget for skeleton loading states.
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFECEEF2),
    this.highlightColor = const Color(0xFFF9FAFC),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1.5, -0.3),
              end: const Alignment(1.5, 0.3),
              stops: const [0.0, 0.5, 1.0],
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (slidePercent * 2 - 1),
      0.0,
      0.0,
    );
  }
}

/// Reusable shimmer container element
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF2),
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}

/// Skeleton placeholder for a post card.
class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.line.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ShimmerBox(width: 34, height: 34, shape: BoxShape.circle),
                const SizedBox(width: 10),
                const ShimmerBox(width: 120, height: 14, borderRadius: 4),
                const Spacer(),
                const ShimmerBox(width: 60, height: 20, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 14),
            const ShimmerBox(
              width: double.infinity,
              height: 18,
              borderRadius: 4,
            ),
            const SizedBox(height: 6),
            const ShimmerBox(width: 240, height: 18, borderRadius: 4),
            const SizedBox(height: 10),
            const ShimmerBox(
              width: double.infinity,
              height: 13,
              borderRadius: 4,
            ),
            const SizedBox(height: 4),
            const ShimmerBox(width: 180, height: 13, borderRadius: 4),
            const SizedBox(height: 16),
            Row(
              children: const [
                ShimmerBox(width: 48, height: 14, borderRadius: 4),
                SizedBox(width: 16),
                ShimmerBox(width: 48, height: 14, borderRadius: 4),
                SizedBox(width: 16),
                ShimmerBox(width: 58, height: 14, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a featured post card.
class FeaturedPostCardSkeleton extends StatelessWidget {
  const FeaturedPostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 261.78,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.line.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(width: double.infinity, height: 160, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 160, height: 16, borderRadius: 4),
                SizedBox(height: 12),
                Row(
                  children: [
                    ShimmerBox(width: 90, height: 12, borderRadius: 4),
                    Spacer(),
                    ShimmerBox(width: 40, height: 12, borderRadius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full dashboard shimmer loading view.
class DashboardShimmerView extends StatelessWidget {
  final bool isSearching;

  const DashboardShimmerView({super.key, this.isSearching = false});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (!isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerBox(width: 130, height: 20, borderRadius: 4),
                  ShimmerBox(width: 60, height: 16, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 262,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    const FeaturedPostCardSkeleton(),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerBox(width: 120, height: 20, borderRadius: 4),
                ShimmerBox(width: 70, height: 14, borderRadius: 4),
              ],
            ),
          ),
          const PostCardSkeleton(),
          const PostCardSkeleton(),
          const PostCardSkeleton(),
        ],
      ),
    );
  }
}
