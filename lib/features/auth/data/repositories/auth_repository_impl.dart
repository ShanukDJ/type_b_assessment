import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<UserEntity, Failure>> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return const FailureResult(
        ValidationFailure(AppStrings.emptyCredentialsError),
      );
    }

    try {
      final userModel = await remoteDataSource.login(
        username: username.trim(),
        password: password.trim(),
        expiresInMins: expiresInMins,
      );

      if (userModel.accessToken != null && userModel.accessToken!.isNotEmpty) {
        await localDataSource.saveToken(userModel.accessToken!);
      }
      await localDataSource.saveUser(userModel);

      return Success(userModel);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return FailureResult(CacheFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure('Unexpected error during login: $e'));
    }
  }

  @override
  Future<Result<UserEntity, Failure>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    if (firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      return const FailureResult(ValidationFailure(AppStrings.fieldRequired));
    }

    try {
      final newUser = await remoteDataSource.register(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        username: username.trim(),
        email: email.trim(),
        password: password.trim(),
      );

      return Success(newUser);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return FailureResult(CacheFailure(e.message));
    } catch (e) {
      return FailureResult(
        ServerFailure('Unexpected error during registration: $e'),
      );
    }
  }

  @override
  Future<Result<UserEntity, Failure>> getCurrentUser() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const FailureResult(AuthFailure('No active session found.'));
      }

      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        final completeUser =
            remoteUser.accessToken != null && remoteUser.accessToken!.isNotEmpty
            ? remoteUser
            : remoteUser.copyWith(accessToken: token);

        await localDataSource.saveUser(completeUser);
        return Success(completeUser);
      } catch (e) {
        final cachedUser = await localDataSource.getUser();
        if (cachedUser != null) {
          return Success(cachedUser);
        }
        if (e is AuthException) {
          await localDataSource.clearSession();
          return FailureResult(
            AuthFailure(e.message, statusCode: e.statusCode),
          );
        }
        if (e is NetworkException) {
          return FailureResult(NetworkFailure(e.message));
        }
        return FailureResult(ServerFailure('Failed to fetch user: $e'));
      }
    } on CacheException catch (e) {
      return FailureResult(CacheFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure('Error checking current user: $e'));
    }
  }

  @override
  Future<Result<bool, Failure>> checkAuthStatus() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const Success(false);
      }
      return const Success(true);
    } on CacheException catch (e) {
      return FailureResult(CacheFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure('Error checking auth status: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      await localDataSource.clearSession();
      return const Success(null);
    } on CacheException catch (e) {
      return FailureResult(CacheFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure('Error during logout: $e'));
    }
  }
}
