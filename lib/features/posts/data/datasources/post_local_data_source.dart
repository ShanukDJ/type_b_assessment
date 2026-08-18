import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/post_response_model.dart';

abstract class PostLocalDataSource {
  Future<void> cachePosts(PostResponseModel postsResponse);
  Future<PostResponseModel?> getCachedPosts();
  Future<void> clearPostsCache();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SecureStorageService storageService;

  PostLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cachePosts(PostResponseModel postsResponse) async {
    try {
      await storageService.savePostsCache(postsResponse.toJson());
    } catch (e) {
      throw CacheException(message: 'Failed to cache posts: $e');
    }
  }

  @override
  Future<PostResponseModel?> getCachedPosts() async {
    try {
      final json = await storageService.getPostsCache();
      if (json == null) return null;
      return PostResponseModel.fromJson(json);
    } catch (e) {
      throw CacheException(message: 'Failed to read cached posts: $e');
    }
  }

  @override
  Future<void> clearPostsCache() async {
    try {
      await storageService.deletePostsCache();
    } catch (e) {
      throw CacheException(message: 'Failed to delete cached posts: $e');
    }
  }
}
