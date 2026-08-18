import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/post_entity.dart';
import '../entities/post_response_entity.dart';

abstract class PostRepository {
  Future<Result<PostResponseEntity, Failure>> getPosts({
    int limit = 10,
    int skip = 0,
  });

  Future<Result<PostResponseEntity, Failure>> searchPosts({
    required String query,
    int limit = 10,
    int skip = 0,
  });

  Future<Result<PostEntity, Failure>> getPostById(int id);
}
