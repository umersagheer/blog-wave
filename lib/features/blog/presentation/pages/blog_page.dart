import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/common/widgets/loader.dart';
import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/core/utils/show_snackbar.dart';
import 'package:blog_wave/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_wave/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_wave/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: ((context) => const BlogPage()));
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    fetchAllBlogs();
  }

  void fetchAllBlogs() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  void deleteBlog(id) {
    context.read<BlogBloc>().add(BlogDelete(id: id));
  }

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
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
          if (state is BlogsDeleteSuccess) {
            showSnackBar(context, state.message);
            fetchAllBlogs();
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                    blog: blog,
                    deleteBlog: deleteBlog,
                    isDissmissable:
                        (context.read<AppUserCubit>().state as AppUserSignedIn)
                                .user
                                .id ==
                            blog.userId
                    // color: index % 2 == 0
                    //     ? AppPallete.gradient1
                    //     : AppPallete.gradient2,
                    );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
