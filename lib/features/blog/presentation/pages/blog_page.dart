import 'package:blog_wave/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: ((context) => const BlogPage()));
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Wave'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
            tooltip: 'Add blog',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "No blogs Yet!",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
