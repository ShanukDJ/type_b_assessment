import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/config/app_config.dart';
import 'package:type_b/core/errors/failures.dart';
import 'package:type_b/core/utils/result.dart';
import 'package:type_b/features/posts/domain/entities/post_entity.dart';
import 'package:type_b/features/posts/domain/entities/post_response_entity.dart';
import 'package:type_b/features/posts/domain/repositories/post_repository.dart';
import 'package:type_b/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:type_b/features/posts/presentation/bloc/posts_event.dart';
import 'package:type_b/features/posts/presentation/bloc/posts_state.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late PostsBloc postsBloc;

  const tPost1 = PostEntity(
    id: 1,
    title: 'Post 1',
    body: 'Body 1',
    tags: ['tech'],
    likes: 15,
    userId: 10,
  );

  const tPost2 = PostEntity(
    id: 2,
    title: 'Post 2',
    body: 'Body 2',
    tags: ['news'],
    likes: 25,
    userId: 20,
  );

  const tPostResponse = PostResponseEntity(
    posts: [tPost1, tPost2],
    total: 2,
    skip: 0,
    limit: 10,
  );

  const tEmptyPostResponse = PostResponseEntity(
    posts: [],
    total: 0,
    skip: 0,
    limit: 10,
  );

  setUp(() {
    mockPostRepository = MockPostRepository();
    postsBloc = PostsBloc(
      postRepository: mockPostRepository,
      appConfig: AppConfig.dev(),
    );
  });

  tearDown(() {
    postsBloc.close();
  });

  group('PostsBloc', () {
    test('initialState_isPostsInitial', () {
      expect(postsBloc.state.status, equals(PostsStatus.initial));
    });

    blocTest<PostsBloc, PostsState>(
      'fetchInitialPosts_onSuccess_emitsLoadingThenLoaded',
      build: () {
        when(
          () => mockPostRepository.getPosts(limit: 10, skip: 0),
        ).thenAnswer((_) async => const Success(tPostResponse));
        return postsBloc;
      },
      act: (bloc) => bloc.add(const FetchInitialPostsEvent()),
      expect: () => [
        const PostsState(status: PostsStatus.loading),
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1, tPost2],
          featuredPosts: [tPost1, tPost2],
          total: 2,
          skip: 2,
          hasReachedMax: true,
          isRefreshing: false,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'fetchInitialPosts_onEmptyList_emitsLoadingThenEmpty',
      build: () {
        when(
          () => mockPostRepository.getPosts(limit: 10, skip: 0),
        ).thenAnswer((_) async => const Success(tEmptyPostResponse));
        return postsBloc;
      },
      act: (bloc) => bloc.add(const FetchInitialPostsEvent()),
      expect: () => [
        const PostsState(status: PostsStatus.loading),
        const PostsState(
          status: PostsStatus.empty,
          posts: [],
          featuredPosts: [],
          total: 0,
          skip: 0,
          hasReachedMax: true,
          isRefreshing: false,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'fetchInitialPosts_onFailure_emitsLoadingThenError',
      build: () {
        when(() => mockPostRepository.getPosts(limit: 10, skip: 0)).thenAnswer(
          (_) async =>
              const FailureResult(ServerFailure('Failed to fetch posts')),
        );
        return postsBloc;
      },
      act: (bloc) => bloc.add(const FetchInitialPostsEvent()),
      expect: () => [
        const PostsState(status: PostsStatus.loading),
        const PostsState(
          status: PostsStatus.error,
          errorMessage: 'Failed to fetch posts',
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'fetchMorePosts_whenHasReachedMax_doesNotFetchAgain',
      build: () => postsBloc,
      seed: () => const PostsState(
        status: PostsStatus.loaded,
        posts: [tPost1],
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const FetchMorePostsEvent()),
      expect: () => [],
      verify: (_) {
        verifyZeroInteractions(mockPostRepository);
      },
    );

    blocTest<PostsBloc, PostsState>(
      'fetchMorePosts_onSuccess_appendsPosts',
      build: () {
        when(() => mockPostRepository.getPosts(limit: 10, skip: 1)).thenAnswer(
          (_) async => const Success(
            PostResponseEntity(posts: [tPost2], total: 2, skip: 1, limit: 10),
          ),
        );
        return postsBloc;
      },
      seed: () => const PostsState(
        status: PostsStatus.loaded,
        posts: [tPost1],
        total: 2,
        skip: 1,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const FetchMorePostsEvent()),
      expect: () => [
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1],
          total: 2,
          skip: 1,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1, tPost2],
          total: 2,
          skip: 2,
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'fetchMorePosts_onFailure_stopsLoadingWithoutAffectingList',
      build: () {
        when(() => mockPostRepository.getPosts(limit: 10, skip: 1)).thenAnswer(
          (_) async => const FailureResult(NetworkFailure('Offline')),
        );
        return postsBloc;
      },
      seed: () => const PostsState(
        status: PostsStatus.loaded,
        posts: [tPost1],
        total: 10,
        skip: 1,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const FetchMorePostsEvent()),
      expect: () => [
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1],
          total: 10,
          skip: 1,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1],
          total: 10,
          skip: 1,
          hasReachedMax: false,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'searchPosts_withQuery_emitsSearchResults',
      build: () {
        when(
          () =>
              mockPostRepository.searchPosts(query: 'tech', limit: 10, skip: 0),
        ).thenAnswer(
          (_) async => const Success(
            PostResponseEntity(posts: [tPost1], total: 1, skip: 0, limit: 10),
          ),
        );
        return postsBloc;
      },
      act: (bloc) => bloc.add(const SearchPostsEvent('tech')),
      expect: () => [
        const PostsState(
          status: PostsStatus.loading,
          isSearching: true,
          searchQuery: 'tech',
        ),
        const PostsState(
          status: PostsStatus.loaded,
          isSearching: true,
          searchQuery: 'tech',
          posts: [tPost1],
          total: 1,
          skip: 1,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'searchPosts_withEmptyQuery_reloadsInitialPosts',
      build: () {
        when(
          () => mockPostRepository.getPosts(limit: 10, skip: 0),
        ).thenAnswer((_) async => const Success(tPostResponse));
        return postsBloc;
      },
      act: (bloc) => bloc.add(const SearchPostsEvent('   ')),
      expect: () => [
        const PostsState(status: PostsStatus.loading),
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1, tPost2],
          featuredPosts: [tPost1, tPost2],
          total: 2,
          skip: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'searchPosts_whenNoResults_emitsPostsEmpty',
      build: () {
        when(
          () => mockPostRepository.searchPosts(
            query: 'nonexistent',
            limit: 10,
            skip: 0,
          ),
        ).thenAnswer((_) async => const Success(tEmptyPostResponse));
        return postsBloc;
      },
      act: (bloc) => bloc.add(const SearchPostsEvent('nonexistent')),
      expect: () => [
        const PostsState(
          status: PostsStatus.loading,
          isSearching: true,
          searchQuery: 'nonexistent',
        ),
        const PostsState(
          status: PostsStatus.empty,
          isSearching: true,
          searchQuery: 'nonexistent',
          posts: [],
          total: 0,
          skip: 0,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'searchPosts_onFailure_emitsPostsError',
      build: () {
        when(
          () =>
              mockPostRepository.searchPosts(query: 'tech', limit: 10, skip: 0),
        ).thenAnswer(
          (_) async => const FailureResult(ServerFailure('Search failed')),
        );
        return postsBloc;
      },
      act: (bloc) => bloc.add(const SearchPostsEvent('tech')),
      expect: () => [
        const PostsState(
          status: PostsStatus.loading,
          isSearching: true,
          searchQuery: 'tech',
        ),
        const PostsState(
          status: PostsStatus.error,
          isSearching: true,
          searchQuery: 'tech',
          errorMessage: 'Search failed',
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'clearSearch_triggersInitialFetch',
      build: () {
        when(
          () => mockPostRepository.getPosts(limit: 10, skip: 0),
        ).thenAnswer((_) async => const Success(tPostResponse));
        return postsBloc;
      },
      act: (bloc) => bloc.add(const ClearSearchEvent()),
      expect: () => [
        const PostsState(status: PostsStatus.loading),
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1, tPost2],
          featuredPosts: [tPost1, tPost2],
          total: 2,
          skip: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'refreshPosts_whenSearching_refreshesSearchQuery',
      build: () {
        when(
          () =>
              mockPostRepository.searchPosts(query: 'tech', limit: 10, skip: 0),
        ).thenAnswer((_) async => const Success(tPostResponse));
        return postsBloc;
      },
      seed: () => const PostsState(
        status: PostsStatus.loaded,
        isSearching: true,
        searchQuery: 'tech',
      ),
      act: (bloc) => bloc.add(const RefreshPostsEvent()),
      expect: () => [
        const PostsState(
          status: PostsStatus.loading,
          isSearching: true,
          searchQuery: 'tech',
        ),
        const PostsState(
          status: PostsStatus.loaded,
          isSearching: true,
          searchQuery: 'tech',
          posts: [tPost1, tPost2],
          total: 2,
          skip: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'selectPost_whenPostInFeed_setsSelectedPostImmediatelyAndFetchesDetails',
      build: () {
        when(
          () => mockPostRepository.getPostById(1),
        ).thenAnswer((_) async => const Success(tPost1));
        return postsBloc;
      },
      seed: () =>
          const PostsState(status: PostsStatus.loaded, posts: [tPost1, tPost2]),
      act: (bloc) => bloc.add(const SelectPostEvent(1)),
      expect: () => [
        const PostsState(
          status: PostsStatus.loaded,
          posts: [tPost1, tPost2],
          selectedPost: tPost1,
          isSelectedPostLoading: false,
        ),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'selectPost_onFailure_setsSelectedPostError',
      build: () {
        when(() => mockPostRepository.getPostById(999)).thenAnswer(
          (_) async => const FailureResult(ServerFailure('Post not found')),
        );
        return postsBloc;
      },
      act: (bloc) => bloc.add(const SelectPostEvent(999)),
      expect: () => [
        const PostsState(isSelectedPostLoading: true),
        const PostsState(
          isSelectedPostLoading: false,
          selectedPostError: 'Post not found',
        ),
      ],
    );
  });
}
