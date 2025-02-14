import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    late final authCubit = context.read<AuthCubit>(); // Get instance of AuthCubit
    late AppUser? currentUser = authCubit.currentUser; // Get current user

    return Scaffold(
      appBar: AppBar(
        title:  Text(currentUser!.email),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authCubit.logout();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Center(

      ),
    );
  }
}
