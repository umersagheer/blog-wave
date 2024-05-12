import 'package:blog_wave/core/theme/app_pallete.dart';
import 'package:blog_wave/core/theme/theme.dart';
import 'package:blog_wave/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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
  List<String> selectedTopics = [];

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('+ Add New Blog'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done),
            tooltip: 'Save blog',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DottedBorder(
                color: AppPallete.borderColor,
                dashPattern: const [15, 5],
                radius: const Radius.circular(10),
                borderType: BorderType.RRect,
                strokeCap: StrokeCap.round,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 50),
                      SizedBox(height: 10),
                      Text('Select Image from Gallery'),
                    ],
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
                                  ? const MaterialStatePropertyAll(
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
              BlogEditor(controller: titleController, hintText: "Blog Title"),
              const SizedBox(height: 10),
              BlogEditor(
                  controller: contentController, hintText: "Blog Content"),
            ],
          ),
        ),
      ),
    );
  }
}
