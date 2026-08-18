import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/errors/failures.dart';
import 'package:type_b/features/posts/data/datasources/post_local_data_source.dart';
import 'package:type_b/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:type_b/features/posts/data/models/post_model.dart';
import 'package:type_b/features/posts/data/models/post_response_model.dart';
import 'package:type_b/features/posts/data/repositories/post_repository_impl.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class FakePostResponseModel extends Fake implements PostResponseModel {}

void main() {
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockPostLocalDataSource mockLocalDataSource;
  late PostRepositoryImpl repository;

  const tPostModel = PostModel(
    id: 1,
    title: 'Test Post',
    body: 'Test Body',
    tags: ['tech'],
    likes: 10,
    userId: 1,
  );

  const tPostResponseModel = PostResponseModel(
    posts: [tPostModel],
    total: 100,
    skip: 0,
    limit: 10,
  );

  setUpAll(() {
    registerFallbackValue(FakePostResponseModel());
  });

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalDataSource = MockPostLocalDataSource();
    repository = PostRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('PostRepositoryImpl', () {
    test(
      'getPosts_onSuccess_returnsSuccessWithPostResponseAndCachesFirstPage',
      () async {
        when(
          () => mockRemoteDataSource.getPosts(limit: 10, skip: 0),
        ).thenAnswer((_) async => tPostResponseModel);
        when(
          () => mockLocalDataSource.cachePosts(any()),
        ).thenAnswer((_) async {});

        final result = await repository.getPosts(limit: 10, skip: 0);

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(tPostResponseModel));
        verify(
          () => mockRemoteDataSource.getPosts(limit: 10, skip: 0),
        ).called(1);
        verify(
          () => mockLocalDataSource.cachePosts(tPostResponseModel),
        ).called(1);
      },
    );

    test(
      'getPosts_onNetworkException_whenCacheExists_returnsCachedPosts',
      () async {
        when(
          () => mockRemoteDataSource.getPosts(limit: 10, skip: 0),
        ).thenThrow(const NetworkException(message: 'Connection timed out'));
        when(
          () => mockLocalDataSource.getCachedPosts(),
        ).thenAnswer((_) async => tPostResponseModel);

        final result = await repository.getPosts(limit: 10, skip: 0);

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(tPostResponseModel));
        verify(() => mockLocalDataSource.getCachedPosts()).called(1);
      },
    );

    test(
      'getPosts_onNetworkException_whenNoCache_returnsNetworkFailure',
      () async {
        when(
          () => mockRemoteDataSource.getPosts(limit: 10, skip: 0),
        ).thenThrow(const NetworkException(message: 'Connection timed out'));
        when(
          () => mockLocalDataSource.getCachedPosts(),
        ).thenAnswer((_) async => null);

        final result = await repository.getPosts(limit: 10, skip: 0);

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<NetworkFailure>());
      },
    );

    test('getPosts_onServerException_returnsServerFailure', () async {
      when(() => mockRemoteDataSource.getPosts(limit: 10, skip: 0)).thenThrow(
        const ServerException(message: 'Server error 500', statusCode: 500),
      );
      when(
        () => mockLocalDataSource.getCachedPosts(),
      ).thenAnswer((_) async => null);

      final result = await repository.getPosts(limit: 10, skip: 0);

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull,
        equals(const ServerFailure('Server error 500', statusCode: 500)),
      );
    });

    test('getPosts_onAuthException_returnsAuthFailure', () async {
      when(() => mockRemoteDataSource.getPosts(limit: 10, skip: 0)).thenThrow(
        const AuthException(message: 'Unauthorized', statusCode: 401),
      );

      final result = await repository.getPosts(limit: 10, skip: 0);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('searchPosts_onSuccess_returnsSuccessWithSearchResults', () async {
      when(
        () =>
            mockRemoteDataSource.searchPosts(query: 'tech', limit: 10, skip: 0),
      ).thenAnswer((_) async => tPostResponseModel);

      final result = await repository.searchPosts(
        query: 'tech',
        limit: 10,
        skip: 0,
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.posts.length, equals(1));
    });

    test('searchPosts_onNetworkException_returnsNetworkFailure', () async {
      when(
        () =>
            mockRemoteDataSource.searchPosts(query: 'tech', limit: 10, skip: 0),
      ).thenThrow(const NetworkException(message: 'No internet'));

      final result = await repository.searchPosts(
        query: 'tech',
        limit: 10,
        skip: 0,
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('getPostById_onSuccess_returnsSuccessWithPost', () async {
      when(
        () => mockRemoteDataSource.getPostById(1),
      ).thenAnswer((_) async => tPostModel);

      final result = await repository.getPostById(1);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(tPostModel));
    });

    test('getPostById_onNetworkException_returnsNetworkFailure', () async {
      when(
        () => mockRemoteDataSource.getPostById(1),
      ).thenThrow(const NetworkException(message: 'Network offline'));

      final result = await repository.getPostById(1);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('getPostById_onNotFound_returnsServerFailure', () async {
      when(() => mockRemoteDataSource.getPostById(999)).thenThrow(
        const ServerException(message: 'Post not found', statusCode: 404),
      );

      final result = await repository.getPostById(999);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
