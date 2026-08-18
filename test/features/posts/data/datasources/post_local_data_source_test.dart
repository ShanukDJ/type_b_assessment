import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/storage/secure_storage_service.dart';
import 'package:type_b/features/posts/data/datasources/post_local_data_source.dart';
import 'package:type_b/features/posts/data/models/post_model.dart';
import 'package:type_b/features/posts/data/models/post_response_model.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorageService;
  late PostLocalDataSourceImpl localDataSource;

  setUp(() {
    mockStorageService = MockSecureStorageService();
    localDataSource = PostLocalDataSourceImpl(
      storageService: mockStorageService,
    );
  });

  const tPostResponse = PostResponseModel(
    posts: [
      PostModel(
        id: 1,
        title: 'Cached Title',
        body: 'Cached Body',
        tags: ['tech'],
        likes: 10,
        userId: 1,
      ),
    ],
    total: 1,
    skip: 0,
    limit: 10,
  );

  group('PostLocalDataSourceImpl', () {
    test('cachePosts_savesToStorageService', () async {
      when(
        () => mockStorageService.savePostsCache(any()),
      ).thenAnswer((_) async {});

      await localDataSource.cachePosts(tPostResponse);

      verify(() => mockStorageService.savePostsCache(any())).called(1);
    });

    test('getCachedPosts_whenDataExists_returnsPostResponseModel', () async {
      when(
        () => mockStorageService.getPostsCache(),
      ).thenAnswer((_) async => tPostResponse.toJson());

      final result = await localDataSource.getCachedPosts();

      expect(result, equals(tPostResponse));
      verify(() => mockStorageService.getPostsCache()).called(1);
    });

    test('getCachedPosts_whenNull_returnsNull', () async {
      when(
        () => mockStorageService.getPostsCache(),
      ).thenAnswer((_) async => null);

      final result = await localDataSource.getCachedPosts();

      expect(result, isNull);
    });

    test('clearPostsCache_delegatesToStorageService', () async {
      when(
        () => mockStorageService.deletePostsCache(),
      ).thenAnswer((_) async {});

      await localDataSource.clearPostsCache();

      verify(() => mockStorageService.deletePostsCache()).called(1);
    });

    test('cachePosts_onException_throwsCacheException', () async {
      when(
        () => mockStorageService.savePostsCache(any()),
      ).thenThrow(Exception('Write error'));

      expect(
        () => localDataSource.cachePosts(tPostResponse),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
