import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/components/c_textfields.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';

import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUsers user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();

  // update profile button pressed
  void updateProfile() {
    // Profile Cubit
    final profileCubit = context.read<ProfileCubit>();

    if (bioController.text.isNotEmpty) {
      profileCubit.updateProfileUsers(
        uid: widget.user.uid,
        newBio: bioController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // Profile Loading
        if(state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 25,),
                  Text("Updating your profile.....")
                ],
              ),
            ),
          );
        } else {
          // Edit Profile Form
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if(state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // Save Profile Button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            // Profile Pic

            // Profile Bio
            const Text("Bio"),
            const SizedBox(
              height: 15,
            ),

            CTextfields(
                controller: bioController,
                hintText: widget.user.bio,
                obscureText: false)
          ],
        ),
      ),
    );
  }
}
