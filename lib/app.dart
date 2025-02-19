import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/data/firebase_post_repo.dart';
import 'package:social/features/search/data/firebase_search_repo.dart';
import 'package:social/features/search/presentation/cubits/search_cubit.dart';
import 'package:social/themes/light_mode.dart';
import 'features/auth/data/firebase_auth_repo.dart';
import 'features/auth/presentation/cubits/auth_cubits.dart';
import 'features/auth/presentation/cubits/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/post/presentation/cubits/post_cubit.dart';
import 'features/profile/data/firebase_profile_repo.dart';
import 'features/profile/presentation/cubits/profile_cubit.dart';
import 'features/storage/data/supabase_storage_repo.dart';

class MyApp extends StatelessWidget {
  // Auth Repo
  final authRepo = FirebaseAuthRepo();

  // Profile Repo
  final profileRepo = FirebaseProfileRepo();

  // Storage Repo
  final storageRepo = SupabaseStorageRepo();

  // Post repo
  final postRepo = FirebasePostRepo();

  // Search repo
  final searchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Providing Multiple Cubit to our app
    return MultiBlocProvider(
      providers: [
        // Auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuthStatus(),
        ),

        // Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: profileRepo,
            storageRepo: storageRepo,
          ),
        ),

        // Post Cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: postRepo,
            storageRepo: storageRepo,
          ),
        ),

        // Search Cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: searchRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            // if user is authenticated, navigate to home page
            if (authState is Authenticated) {
              return const HomeScreen();
            }

            // if user is not authenticated, navigate to auth page
            else if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // if user is loading, show loading screen
            else if (authState is AuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Default case (Prevents returning null)
            return const Scaffold(
              body: Center(
                child: Text("Something went wrong. Please restart the app."),
              ),
            );
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
