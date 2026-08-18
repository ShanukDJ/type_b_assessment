import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/post_response_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource? localDataSource;

  PostRepositoryImpl({required this.remoteDataSource, this.localDataSource});

  @override
  Future<Result<PostResponseEntity, Failure>> getPosts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await remoteDataSource.getPosts(
        limit: limit,
        skip: skip,
      );

      // Cache first page for offline viewing
      if (skip == 0 && localDataSource != null) {
        await localDataSource!.cachePosts(response);
      }

      return Success(response);
    } on NetworkException catch (e) {
      if (skip == 0 && localDataSource != null) {
        final cached = await localDataSource!.getCachedPosts();
        if (cached != null && cached.posts.isNotEmpty) {
          return Success(cached);
        }
      }
      return FailureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      if (skip == 0 && localDataSource != null) {
        final cached = await localDataSource!.getCachedPosts();
        if (cached != null && cached.posts.isNotEmpty) {
          return Success(cached);
        }
      }
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      if (skip == 0 && localDataSource != null) {
        final cached = await localDataSource!.getCachedPosts();
        if (cached != null && cached.posts.isNotEmpty) {
          return Success(cached);
        }
      }
      return FailureResult(
        ServerFailure('Unexpected error fetching posts: $e'),
      );
    }
  }

  @override
  Future<Result<PostResponseEntity, Failure>> searchPosts({
    required String query,
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await remoteDataSource.searchPosts(
        query: query.trim(),
        limit: limit,
        skip: skip,
      );
      return Success(response);
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(
        ServerFailure('Unexpected error searching posts: $e'),
      );
    }
  }

  @override
  Future<Result<PostEntity, Failure>> getPostById(int id) async {
    try {
      final response = await remoteDataSource.getPostById(id);
      return Success(response);
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(
        ServerFailure('Unexpected error fetching post #$id: $e'),
      );
    }
  }
}
