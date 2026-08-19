import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/featured_posts_section.dart';
import '../widgets/post_card_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'post_detail_page.dart';

class DashboardPage extends StatefulWidget {
  final AppConfig appConfig;
  final VoidCallback onProfileTap;

  const DashboardPage({
    super.key,
    required this.appConfig,
    required this.onProfileTap,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool>? _networkSubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _checkNetwork();
    _listenNetwork();
  }

  Future<void> _checkNetwork() async {
    try {
      final networkInfo = context.read<NetworkInfoService>();
      final isConnected = await networkInfo.isConnected;
      if (mounted) {
        setState(() {
          _isOffline = !isConnected;
        });
      }
    } catch (_) {}
  }

  void _listenNetwork() {
    try {
      final networkInfo = context.read<NetworkInfoService>();
      _networkSubscription = networkInfo.onConnectivityChanged.listen((
        isConnected,
      ) {
        if (mounted) {
          setState(() {
            _isOffline = !isConnected;
          });
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      context.read<PostsBloc>().add(const FetchMorePostsEvent());
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _navigateToDetail(PostEntity post) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PostDetailPage(post: post)));
  }

  @override
  Widget build(BuildContext context) {
    final gridColumns = ResponsiveLayout.getGridColumnCount(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DashboardHeader(onProfileTap: widget.onProfileTap),
            if (_isOffline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppColors.warning.withValues(alpha: 0.15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.warning,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppStrings.offlineModeTitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SearchBarWidget(appConfig: widget.appConfig),
            Expanded(
              child: BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  if (state.status == PostsStatus.loading &&
                      state.posts.isEmpty) {
                    return DashboardShimmerView(isSearching: state.isSearching);
                  }

                  if (state.status == PostsStatus.error &&
                      state.posts.isEmpty) {
                    return ErrorView(
                      message:
                          state.errorMessage ?? AppStrings.defaultErrorMessage,
                      onRetry: () {
                        context.read<PostsBloc>().add(
                          const FetchInitialPostsEvent(),
                        );
                      },
                    );
                  }

                  if (state.status == PostsStatus.empty ||
                      (state.status == PostsStatus.loaded &&
                          state.posts.isEmpty)) {
                    return EmptyView(
                      title: state.isSearching
                          ? AppStrings.noMatchingPosts
                          : AppStrings.noPostsAvailable,
                      message: state.isSearching
                          ? 'No articles found matching "${state.searchQuery}". Try a different keyword.'
                          : AppStrings.noArticlesAvailableMessage,
                      action: state.isSearching
                          ? TextButton(
                              onPressed: () {
                                context.read<PostsBloc>().add(
                                  const ClearSearchEvent(),
                                );
                              },
                              child: Text(
                                AppStrings.clearSearch,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<PostsBloc>().add(const RefreshPostsEvent());
                    },
                    color: AppColors.primary1,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        if (!state.isSearching &&
                            state.featuredPosts.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: FeaturedPostsSection(
                              featuredPosts: state.featuredPosts,
                              onPostTap: _navigateToDetail,
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        ],
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 36,
                              bottom: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.isSearching
                                      ? '${AppStrings.searchResults} (${state.total})'
                                      : AppStrings.recentPosts,
                                  style: AppTextStyles.sectionTitle,
                                ),
                                if (!state.isSearching)
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      AppStrings.viewAll,
                                      style: AppTextStyles.viewAll,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (gridColumns > 1)
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gridColumns,
                                    childAspectRatio: 1.15,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final post = state.posts[index];
                                return PostCardWidget(
                                  post: post,
                                  onTap: () => _navigateToDetail(post),
                                );
                              }, childCount: state.posts.length),
                            ),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final post = state.posts[index];
                              return PostCardWidget(
                                post: post,
                                onTap: () => _navigateToDetail(post),
                              );
                            }, childCount: state.posts.length),
                          ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: state.isLoadingMore
                                ? const Center(
                                    child: LoadingIndicator(size: 24),
                                  )
                                : state.hasReachedMax && state.posts.isNotEmpty
                                ? Center(
                                    child: Text(
                                      AppStrings.reachedEndOfFeed,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.secondary.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
