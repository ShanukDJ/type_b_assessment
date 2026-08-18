import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/services/biometric_service.dart';
import 'core/services/network_info_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/home/presentation/pages/main_navigation_screen.dart';
import 'features/posts/data/datasources/post_local_data_source.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/presentation/bloc/posts_bloc.dart';
import 'features/posts/presentation/bloc/posts_event.dart';

class NewsBayApp extends StatelessWidget {
  final AppConfig appConfig;
  final SecureStorageService? secureStorageService;
  final ApiClient? apiClient;
  final AuthRepository? authRepository;
  final PostRepository? postRepository;
  final BiometricService? biometricService;
  final NetworkInfoService? networkInfoService;

  const NewsBayApp({
    super.key,
    required this.appConfig,
    this.secureStorageService,
    this.apiClient,
    this.authRepository,
    this.postRepository,
    this.biometricService,
    this.networkInfoService,
  });

  @override
  Widget build(BuildContext context) {
    // Composition Root / Dependency Injection
    final storage = secureStorageService ?? SecureStorageServiceImpl();
    final client =
        apiClient ?? ApiClient(appConfig: appConfig, storageService: storage);

    final authRepo =
        authRepository ??
        AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSourceImpl(apiClient: client),
          localDataSource: AuthLocalDataSourceImpl(storageService: storage),
        );

    final postRepo =
        postRepository ??
        PostRepositoryImpl(
          remoteDataSource: PostRemoteDataSourceImpl(apiClient: client),
          localDataSource: PostLocalDataSourceImpl(storageService: storage),
        );

    final bioService = biometricService ?? BiometricServiceImpl();
    final netService = networkInfoService ?? NetworkInfoServiceImpl();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppConfig>.value(value: appConfig),
        RepositoryProvider<AuthRepository>.value(value: authRepo),
        RepositoryProvider<PostRepository>.value(value: postRepo),
        RepositoryProvider<BiometricService>.value(value: bioService),
        RepositoryProvider<NetworkInfoService>.value(value: netService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: authRepo, biometricService: bioService)
                  ..add(const AppStartedEvent()),
          ),
          BlocProvider<PostsBloc>(
            create: (context) =>
                PostsBloc(postRepository: postRepo, appConfig: appConfig)
                  ..add(const FetchInitialPostsEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'NewsBay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AppRootView(),
        ),
      ),
    );
  }
}

class AppRootView extends StatelessWidget {
  const AppRootView({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfig = context.read<AppConfig>();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Trigger fresh post fetch when authenticated
          context.read<PostsBloc>().add(const FetchInitialPostsEvent());
        }
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashPage();
        } else if (state is Authenticated) {
          return MainNavigationScreen(appConfig: appConfig);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
