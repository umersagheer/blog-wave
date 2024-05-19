import 'dart:io';

import 'package:blog_wave/core/constants/constants.dart';
import 'package:blog_wave/core/error/exceptions.dart';
import 'package:blog_wave/core/error/failures.dart';
import 'package:blog_wave/core/network/connection_checker.dart';
import 'package:blog_wave/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_wave/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_wave/features/blog/data/models/blog_model.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);

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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
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
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
