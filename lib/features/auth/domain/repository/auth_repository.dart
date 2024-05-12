import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String email, required String password});
}
