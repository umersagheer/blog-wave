import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content, [String? type]) {
  type = type ?? "";
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: type == "success"
            ? const Color.fromARGB(255, 172, 232, 156)
            : const Color.fromARGB(255, 232, 156, 156),
        showCloseIcon: true,
      ),
    );
}
