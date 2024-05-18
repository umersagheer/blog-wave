import 'dart:io';
import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      title: params.title,
      userId: params.userId,
      content: params.content,
      image: params.image,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String title;
  final String userId;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.title,
    required this.userId,
    required this.content,
    required this.image,
    required this.topics,
  });
}
