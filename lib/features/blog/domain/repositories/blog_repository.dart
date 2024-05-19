import 'dart:io';
import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required String title,
    required String userId,
    required String content,
    required File image,
    required List<String> topics,
  });
  // Future<String> uploadBlogImage({
  //   required File image,
  //   required BlogModel blog,
  // });
}
