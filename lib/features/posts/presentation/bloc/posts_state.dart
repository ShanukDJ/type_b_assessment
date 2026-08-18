import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

enum PostsStatus { initial, loading, loaded, empty, error }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<PostEntity> posts;
  final List<PostEntity> featuredPosts;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String searchQuery;
  final bool isSearching;
  final String? errorMessage;
  final int total;
  final int skip;
  final PostEntity? selectedPost;
  final bool isSelectedPostLoading;
  final String? selectedPostError;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.featuredPosts = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.searchQuery = '',
    this.isSearching = false,
    this.errorMessage,
    this.total = 0,
    this.skip = 0,
    this.selectedPost,
    this.isSelectedPostLoading = false,
    this.selectedPostError,
  });

  bool get isFeedEmpty => posts.isEmpty && status == PostsStatus.loaded;

  PostsState copyWith({
    PostsStatus? status,
    List<PostEntity>? posts,
    List<PostEntity>? featuredPosts,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? searchQuery,
    bool? isSearching,
    String? errorMessage,
    int? total,
    int? skip,
    PostEntity? selectedPost,
    bool? isSelectedPostLoading,
    String? selectedPostError,
    bool clearSelectedPost = false,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      featuredPosts: featuredPosts ?? this.featuredPosts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      selectedPost: clearSelectedPost
          ? null
          : (selectedPost ?? this.selectedPost),
      isSelectedPostLoading:
          isSelectedPostLoading ?? this.isSelectedPostLoading,
      selectedPostError: selectedPostError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    featuredPosts,
    hasReachedMax,
    isLoadingMore,
    isRefreshing,
    searchQuery,
    isSearching,
    errorMessage,
    total,
    skip,
    selectedPost,
    isSelectedPostLoading,
    selectedPostError,
  ];
}
