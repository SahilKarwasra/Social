import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';

import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({
    super.key,
    required this.uid
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // grab cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // grab current user from cubit
  late AppUser? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();
    // fetch profile user data
    profileCubit.fetchProfileUsers(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // if state is loaded, show Profile Screen
        if (state is ProfileLoaded) {
          // final loaded user
          final loadedUser = state.profileUser;

          // Main Profile Scaffold
          return Scaffold(
            appBar: AppBar(
              title: Text(loadedUser.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
            ),

            // Body of the screen
            body: Column(

            ),
          );
        }

        // if state is loading, show loading screen
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong. Please restart the app."),
            ),
          );
        }
      }
    );
  }
}
