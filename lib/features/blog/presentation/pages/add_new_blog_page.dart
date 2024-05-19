import 'dart:io';

import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/common/widgets/loader.dart';
import 'package:blog_wave/core/utils/pick_image.dart';
import 'package:blog_wave/core/utils/show_snackbar.dart';
import 'package:blog_wave/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_wave/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const AddNewBlogPage()));

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserSignedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              title: titleController.text.trim(),
              userId: userId,
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
      print(userId + "userid");
      print("im from upload blog inside the if of formkey");
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('+ Add New Blog'),
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done),
            tooltip: 'Save blog',
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        } else if (state is BlogSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
        }
      }, builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  image != null
                      ? //Image.file(image!)
                      GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image!.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => selectImage(),
                          child: DottedBorder(
                            color: AppPallete.borderColor,
                            dashPattern: const [15, 5],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: const SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 50),
                                  SizedBox(height: 10),
                                  Text('Select Image from Gallery'),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'Technology',
                        'Business',
                        'Entertainment',
                        'Sports',
                        'Programming'
                      ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                  } else {
                                    selectedTopics.add(e);
                                  }
                                  setState(() {});
                                },
                                child: Chip(
                                  color: selectedTopics.contains(e)
                                      ? const WidgetStatePropertyAll(
                                          AppPallete.gradient1)
                                      : null,
                                  label: Text(e),
                                  side: selectedTopics.contains(e)
                                      ? const BorderSide(
                                          color: AppPallete.gradient1)
                                      : const BorderSide(
                                          color: AppPallete.borderColor),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlogEditor(
                      controller: titleController, hintText: "Blog Title"),
                  const SizedBox(height: 10),
                  BlogEditor(
                      controller: contentController, hintText: "Blog Content"),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
