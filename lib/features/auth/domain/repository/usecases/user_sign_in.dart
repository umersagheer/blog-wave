import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/core/entities/user.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;
  const UserSignIn({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
