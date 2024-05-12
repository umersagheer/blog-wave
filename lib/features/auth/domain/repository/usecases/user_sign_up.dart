import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/features/auth/domain/entities/user.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams(
      {required this.name, required this.email, required this.password});
}
