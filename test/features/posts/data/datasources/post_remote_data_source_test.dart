import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/network/api_client.dart';
import 'package:type_b/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:type_b/features/posts/data/models/post_model.dart';
import 'package:type_b/features/posts/data/models/post_response_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late PostRemoteDataSourceImpl dataSource;

  final tPostJson = {
    'id': 1,
    'title': 'Test Post',
    'body': 'Test Body',
    'tags': ['tech'],
    'reactions': {'likes': 10, 'dislikes': 0},
    'views': 50,
    'userId': 1,
  };

  final tPostsResponseJson = {
    'posts': [tPostJson],
    'total': 100,
    'skip': 0,
    'limit': 10,
  };

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = PostRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('PostRemoteDataSourceImpl', () {
    test('getPosts_returnsPostResponseModel', () async {
      when(
        () => mockApiClient.get<Map<String, dynamic>>(
          '/posts',
          queryParameters: {'limit': 10, 'skip': 0},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/posts'),
          data: tPostsResponseJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getPosts(limit: 10, skip: 0);

      expect(result, isA<PostResponseModel>());
      expect(result.posts.length, equals(1));
      expect(result.total, equals(100));
    });

    test('searchPosts_returnsPostResponseModel', () async {
      when(
        () => mockApiClient.get<Map<String, dynamic>>(
          '/posts/search',
          queryParameters: {'q': 'tech', 'limit': 10, 'skip': 0},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/posts/search'),
          data: tPostsResponseJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.searchPosts(
        query: 'tech',
        limit: 10,
        skip: 0,
      );

      expect(result, isA<PostResponseModel>());
      expect(result.posts.first.title, equals('Test Post'));
    });

    test('getPostById_returnsPostModel', () async {
      when(
        () => mockApiClient.get<Map<String, dynamic>>('/posts/1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/posts/1'),
          data: tPostJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getPostById(1);

      expect(result, isA<PostModel>());
      expect(result.id, equals(1));
      expect(result.title, equals('Test Post'));
    });

    test('getPosts_whenEmptyResponse_throwsServerException', () async {
      when(
        () => mockApiClient.get<Map<String, dynamic>>(
          '/posts',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/posts'),
          data: null,
          statusCode: 200,
        ),
      );

      expect(
        () => dataSource.getPosts(limit: 10, skip: 0),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
