import 'package:blog_wave/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_wave/core/network/connection_checker.dart';
import 'package:blog_wave/core/secrets/app_secrets.dart';
import 'package:blog_wave/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_wave/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_wave/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/current_user.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/user_sign_in.dart';
import 'package:blog_wave/features/auth/domain/repository/usecases/user_sign_up.dart';
import 'package:blog_wave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_wave/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_wave/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_wave/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_wave/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_wave/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_wave/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_wave/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_wave/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
// ignore: unused_import
import 'package:universal_io/io.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
