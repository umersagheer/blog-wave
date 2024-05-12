import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscureText;

  const BlogEditor(
      {super.key,
      required this.controller,
      required this.hintText,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(fontSize: 18),
      ),
      maxLines: null,
      validator: (value) => value!.isEmpty ? '$hintText is missing!' : null,
      obscureText: isObscureText,
    );
  }
}
