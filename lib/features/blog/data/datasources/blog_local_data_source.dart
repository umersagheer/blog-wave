import 'dart:convert';

import 'package:blog_wave/features/blog/data/models/blog_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class BlogLocalDataSource {
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final SharedPreferences prefs;
  BlogLocalDataSourceImpl(this.prefs);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    for (int i = 0; i < blogs.length; i++) {
      blogs.add(
          BlogModel.fromJson(jsonDecode(prefs.get(i.toString()) as String)));
    }
    return blogs;
  }

  @override
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs}) async {
    for (int i = 0; i < blogs.length; i++) {
      await prefs.setString(i.toString(), jsonEncode(blogs[i].toJson()));
    }
  }
}
