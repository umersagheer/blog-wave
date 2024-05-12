import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/core/entities/user.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  const CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
