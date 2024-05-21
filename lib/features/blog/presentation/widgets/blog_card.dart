import 'dart:math';

import 'package:blog_wave/core/common/widgets/loader.dart';
import 'package:blog_wave/core/constants/constants.dart';
import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/core/utils/calculate_reading_time.dart';
import 'package:blog_wave/core/utils/show_snackbar.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_wave/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final void Function(String) deleteBlog;
  final bool isDissmissable;
  // final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.isDissmissable,
    required this.deleteBlog,
    // required this.color,
  });
  final Map<String, List<String>> img = Constants.images;

  Future<dynamic> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text(
            'Are You Sure You Want To Delete This Blog?',
          ),
          actions: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Dismissible(
        key: Key(blog.id),
        confirmDismiss: (direction) async {
          if (isDissmissable) {
            var delete = await _dialogBuilder(context);
            if (delete) {
              (() => deleteBlog(blog.id))();
              return true;
            }
          }
          return false;
        },
        onDismissed: (direction) async {},
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(16).copyWith(
            bottom: 4,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "images/${img[blog.topics[Random().nextInt(blog.topics.length)]]![Random().nextInt(img[blog.topics.first]!.length)]}"),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(69, 24, 24, 32), BlendMode.srcOver)
                // colorFilter:
                //     const ColorFilter.mode(Colors.purple, BlendMode.lighten)
                ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.topics
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(
                                label: Text(e),
                                color: MaterialStatePropertyAll(
                                    Colors.purple[700]),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${calculateReadingTime(blog.content)} min'),
                  CircleAvatar(
                    backgroundColor: AppPallete.gradient2,
                    child: Text(blog.posterName!.split(' ').first[0] +
                            blog.posterName!.split(' ').last[0] ??
                        "AN"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
