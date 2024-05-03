import 'package:blog_wave/core/theme/theme.dart';
import 'package:blog_wave/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        title: 'Blog Wave',
        home: const SignUpPage());
  }
}
