import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/theme/theme.dart';
import 'package:blog_wave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_wave/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_wave/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_wave/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserSignedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      title: 'Blog Wave',
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserSignedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
