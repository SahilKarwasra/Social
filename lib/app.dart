import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/themes/light_mode.dart';

import 'features/auth/data/firebase_auth_repo.dart';
import 'features/auth/presentation/cubits/auth_cubits.dart';
import 'features/auth/presentation/cubits/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'main_page_with_bottom_bar.dart';

class MyApp extends StatelessWidget {
  // Auth Repo
  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Providing Cubit to our app
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuthStatus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {

            // if user is authenticated, navigate to home page
            if (authState is Authenticated) {
              return const MainPageWithBottomBar();
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
