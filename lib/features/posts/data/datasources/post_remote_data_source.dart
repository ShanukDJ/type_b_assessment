import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';

abstract class PostRemoteDataSource {
  Future<PostResponseModel> getPosts({int limit = 10, int skip = 0});

  Future<PostResponseModel> searchPosts({
    required String query,
    int limit = 10,
    int skip = 0,
  });

  Future<PostModel> getPostById(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PostResponseModel> getPosts({int limit = 10, int skip = 0}) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/posts',
        queryParameters: {'limit': limit, 'skip': skip},
      );

      if (response.data != null) {
        return PostResponseModel.fromJson(response.data!);
      } else {
        throw const ServerException(
          message: 'Empty response when fetching posts',
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to fetch posts: $e');
    }
  }

  @override
  Future<PostResponseModel> searchPosts({
    required String query,
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/posts/search',
        queryParameters: {'q': query, 'limit': limit, 'skip': skip},
      );

      if (response.data != null) {
        return PostResponseModel.fromJson(response.data!);
      } else {
        throw const ServerException(
          message: 'Empty response when searching posts',
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to search posts: $e');
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>('/posts/$id');

      if (response.data != null) {
        return PostModel.fromJson(response.data!);
      } else {
        throw const ServerException(
          message: 'Empty response when fetching post detail',
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to fetch post #$id: $e');
    }
  }
}
