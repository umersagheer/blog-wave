import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/common/widgets/loader.dart';
import 'package:blog_wave/core/entities/user.dart';
import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/core/utils/show_snackbar.dart';
import 'package:blog_wave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_wave/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_wave/features/blog/domain/entitites/blog.dart';
import 'package:blog_wave/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_wave/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_wave/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route(bool? myBlogs) => MaterialPageRoute(
      builder: ((context) => BlogPage(
            myBlogs: myBlogs ?? false,
          )));
  final bool myBlogs;
  const BlogPage({Key? key, required this.myBlogs}) : super(key: key);

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
    User? user;
    setState(() {
      user = (context.read<AppUserCubit>().state as AppUserSignedIn).user;
    });

    void signOut() {
      // (context.read<AppUserCubit>().updateUser(null));
      (context.read<AuthBloc>().add(AuthSignOut()));
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          backgroundColor: AppPallete.gradient2,
          foregroundColor: Colors.white,
          // elevation: 10.0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Blog Wave'),
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(153, 49, 49, 49)),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppPallete.gradient2,
                        child: Icon(Icons.person),
                      ),
                      Text(user!.name)
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: ElevatedButton.icon(
                      style: ButtonStyle.lerp(
                          const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.redAccent)),
                          const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          0),
                      label: const Text("Logout"),
                      onPressed: signOut,
                      icon: const Icon(Icons.logout)),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: () {
                  if (widget.myBlogs)
                    Navigator.pushAndRemoveUntil(
                        context, BlogPage.route(false), (route) => false);
                },
                iconSize: !widget.myBlogs ? 32.0 : 22.0,
                isSelected: !widget.myBlogs,
                icon: Icon(Icons.dynamic_feed_outlined),
                tooltip: "Timeline",
              ),
              IconButton(
                onPressed: () {
                  if (!widget.myBlogs)
                    Navigator.pushAndRemoveUntil(
                        context, BlogPage.route(true), (route) => false);
                },
                isSelected: widget.myBlogs,
                iconSize: widget.myBlogs ? 32.0 : 22.0,
                icon: const Icon(Icons.format_list_bulleted_sharp),
                tooltip: "My Blogs",
              ),
            ],
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignOutState) {
              showSnackBar(context, state.message, "success");
              Navigator.pushAndRemoveUntil(
                context,
                SignInPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return BlocConsumer<BlogBloc, BlogState>(
              listener: (context, state) {
                if (state is BlogFailure) {
                  showSnackBar(context, state.error);
                }
                if (state is BlogsDeleteSuccess) {
                  showSnackBar(context, state.message, "success");
                  fetchAllBlogs();
                }
              },
              builder: (context, state) {
                if (state is BlogLoading) {
                  return const Loader();
                }
                if (state is BlogsDisplaySuccess) {
                  List<Blog> filteredArray = state.blogs
                      .where((element) => widget.myBlogs
                          ? element.userId == user!.id
                          : element.userId != user!.id)
                      .toList();

                  return filteredArray.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredArray.length,
                          itemBuilder: (context, index) {
                            final blog = filteredArray[index];
                            return BlogCard(
                                blog: blog,
                                deleteBlog: deleteBlog,
                                isDissmissable: (context
                                            .read<AppUserCubit>()
                                            .state as AppUserSignedIn)
                                        .user
                                        .id ==
                                    blog.userId
                                // color: index % 2 == 0
                                //     ? AppPallete.gradient1
                                //     : AppPallete.gradient2,
                                );
                          },
                        )
                      : Center(
                          child: Text("No Blogs Yet :("),
                        );
                }
                return const SizedBox();
              },
            );
          },
        ));
  }
}
