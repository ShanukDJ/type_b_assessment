import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity, Failure>> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  });

  Future<Result<UserEntity, Failure>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  });

  Future<Result<UserEntity, Failure>> getCurrentUser();

  Future<Result<bool, Failure>> checkAuthStatus();

  Future<Result<void, Failure>> logout();
}
