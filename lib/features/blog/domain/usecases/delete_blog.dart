import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<String, DeleteBlogParams> {
  final BlogRepository blogRepository;
  DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, String>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(params.id);
  }
}

class DeleteBlogParams {
  final String id;

  DeleteBlogParams({
    required this.id,
  });
}
