import 'package:blog_wave/core/secrets/app_secrets.dart';
import 'package:blog_wave/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_wave/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
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
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
