import 'dart:io';

import 'package:blog_wave/core/error/exceptions.dart';
import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_wave/features/blog/data/models/blog_model.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl(this.blogRemoteDataSource);
  // final SupabaseClient supabaseClient;
  // BlogRemoteDataSourceImpl(this.supabaseClient);

  // @override
  // Future<BlogModel> uploadBlog(BlogModel blog) async {
  //   try {
  //     final blogData =
  //         await supabaseClient.from("blogs").insert(blog.toJson()).select();
  //     return BlogModel.fromJson(blogData.first);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  // @override
  // Future<String> uploadBlogImage({
  //   required File image,
  //   required BlogModel blog,
  // }) async {
  //   try {
  //     await supabaseClient.storage.from("blog_images").upload(
  //           blog.id,
  //           image,
  //         );
  //     return supabaseClient.storage.from("blog_images").getPublicUrl(blog.id);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required String title,
    required String userId,
    required String content,
    required File image,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        title: title,
        userId: userId,
        content: content,
        imageURL: "imageURL",
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageURL = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageURL: imageURL,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return Right(uploadedBlog);
    } on ServerException catch (e) {
      throw left(Failure(e.message));
    }
  }
}
