import 'package:blog_wave/core/error/exceptions.dart';
import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_wave/features/auth/domain/entities/user.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailAndPassword(
          name: name, email: email, password: password);

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
}
