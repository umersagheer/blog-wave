import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/secrets/app_secrets.dart';
import 'package:blog_wave/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_wave/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/current_user.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/user_sign_in.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/user_sign_up.dart';
import 'package:blog_wave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey);
  serviceLocator.registerLazySingleton(() => supabase.client);
  _initAuth();

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

// Datasource

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

// Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

// Usecases
  serviceLocator.registerFactory(
    () => UserSignUp(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignIn(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
