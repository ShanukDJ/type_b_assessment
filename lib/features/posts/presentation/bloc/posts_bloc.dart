import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../domain/repositories/post_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;
  final AppConfig appConfig;

  PostsBloc({required this.postRepository, required this.appConfig})
    : super(const PostsState()) {
    on<FetchInitialPostsEvent>(_onFetchInitialPosts);
    on<FetchMorePostsEvent>(_onFetchMorePosts);
    on<SearchPostsEvent>(_onSearchPosts);
    on<ClearSearchEvent>(_onClearSearch);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<SelectPostEvent>(_onSelectPost);
  }

  int get _limit => appConfig.paginationLimit;

  Future<void> _onFetchInitialPosts(
    FetchInitialPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (event.isRefresh) {
      emit(state.copyWith(isRefreshing: true, errorMessage: null));
    } else {
      emit(
        state.copyWith(
          status: PostsStatus.loading,
          isSearching: false,
          searchQuery: '',
          errorMessage: null,
        ),
      );
    }

    final result = await postRepository.getPosts(limit: _limit, skip: 0);

    result.when(
      success: (response) {
        if (response.posts.isEmpty) {
          emit(
            state.copyWith(
              status: PostsStatus.empty,
              posts: const [],
              featuredPosts: const [],
              total: 0,
              skip: 0,
              hasReachedMax: true,
              isRefreshing: false,
            ),
          );
        } else {
          final featured = response.posts.take(4).toList();
          emit(
            state.copyWith(
              status: PostsStatus.loaded,
              posts: response.posts,
              featuredPosts: featured,
              total: response.total,
              skip: response.posts.length,
              hasReachedMax: response.hasReachedMax,
              isRefreshing: false,
            ),
          );
        }
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: PostsStatus.error,
            errorMessage: failure.message,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  Future<void> _onFetchMorePosts(
    FetchMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.status != PostsStatus.loaded) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final currentSkip = state.posts.length;
    final result = state.isSearching
        ? await postRepository.searchPosts(
            query: state.searchQuery,
            limit: _limit,
            skip: currentSkip,
          )
        : await postRepository.getPosts(limit: _limit, skip: currentSkip);

    result.when(
      success: (response) {
        if (response.posts.isEmpty) {
          emit(state.copyWith(hasReachedMax: true, isLoadingMore: false));
        } else {
          final updatedPosts = List.of(state.posts)..addAll(response.posts);
          final hasReachedMax =
              updatedPosts.length >= response.total ||
              response.posts.length < _limit;

          emit(
            state.copyWith(
              posts: updatedPosts,
              skip: updatedPosts.length,
              total: response.total,
              hasReachedMax: hasReachedMax,
              isLoadingMore: false,
            ),
          );
        }
      },
      failure: (_) {
        emit(state.copyWith(isLoadingMore: false));
      },
    );
  }

  Future<void> _onSearchPosts(
    SearchPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      add(const FetchInitialPostsEvent());
      return;
    }

    emit(
      state.copyWith(
        status: PostsStatus.loading,
        isSearching: true,
        searchQuery: query,
        errorMessage: null,
      ),
    );

    final result = await postRepository.searchPosts(
      query: query,
      limit: _limit,
      skip: 0,
    );

    result.when(
      success: (response) {
        if (response.posts.isEmpty) {
          emit(
            state.copyWith(
              status: PostsStatus.empty,
              posts: const [],
              total: 0,
              skip: 0,
              hasReachedMax: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: PostsStatus.loaded,
              posts: response.posts,
              total: response.total,
              skip: response.posts.length,
              hasReachedMax: response.hasReachedMax,
            ),
          );
        }
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: PostsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<PostsState> emit) {
    add(const FetchInitialPostsEvent());
  }

  void _onRefreshPosts(RefreshPostsEvent event, Emitter<PostsState> emit) {
    if (state.isSearching && state.searchQuery.isNotEmpty) {
      add(SearchPostsEvent(state.searchQuery));
    } else {
      add(const FetchInitialPostsEvent(isRefresh: true));
    }
  }

  Future<void> _onSelectPost(
    SelectPostEvent event,
    Emitter<PostsState> emit,
  ) async {
    final existingIndex = state.posts.indexWhere((p) => p.id == event.postId);
    if (existingIndex != -1) {
      emit(
        state.copyWith(
          selectedPost: state.posts[existingIndex],
          isSelectedPostLoading: false,
          selectedPostError: null,
        ),
      );
    } else {
      emit(
        state.copyWith(isSelectedPostLoading: true, selectedPostError: null),
      );
    }

    final result = await postRepository.getPostById(event.postId);

    result.when(
      success: (post) {
        emit(
          state.copyWith(
            selectedPost: post,
            isSelectedPostLoading: false,
            selectedPostError: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isSelectedPostLoading: false,
            selectedPostError: failure.message,
          ),
        );
      },
    );
  }
}
