import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/post_entity.dart';
import 'featured_post_card.dart';

class FeaturedPostsSection extends StatelessWidget {
  final List<PostEntity> featuredPosts;
  final void Function(PostEntity post) onPostTap;

  const FeaturedPostsSection({
    super.key,
    required this.featuredPosts,
    required this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    if (featuredPosts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.featuredPosts, style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(AppStrings.viewAll, style: AppTextStyles.viewAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 262,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: featuredPosts.length,
            itemBuilder: (context, index) {
              final post = featuredPosts[index];
              return FeaturedPostCard(post: post, onTap: () => onPostTap(post));
            },
          ),
        ),
      ],
    );
  }
}
