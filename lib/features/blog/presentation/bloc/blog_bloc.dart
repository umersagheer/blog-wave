import 'dart:io';
import 'package:blog_wave/core/usecase/usecase.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_wave/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_wave/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _deleteBlog = deleteBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogDelete>(_onDeleteBlog);
  }
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
          title: event.title,
          userId: event.userId,
          content: event.content,
          image: event.image,
          topics: event.topics),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onDeleteBlog(
    BlogDelete event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _deleteBlog(DeleteBlogParams(id: event.id));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDeleteSuccess(r)),
    );
  }
}
