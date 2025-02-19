import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/components/c_textfields.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:social/responsive/constrained_scaffold.dart';

import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUsers user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Mobile Image pick
  PlatformFile? imagePicketFile;

  // Web Image pick
  Uint8List? imageWebBytes;

  // Bio Controller
  final bioController = TextEditingController();

  // pick Image
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePicketFile = result.files.first;

        if (kIsWeb) {
          imageWebBytes = imagePicketFile!.bytes;
        }
      });
    }
  }

  // update profile button pressed
  void updateProfile() {
    // Profile Cubit
    final profileCubit = context.read<ProfileCubit>();

    // setup images, bio and userId
    final String uid = widget.user.uid;
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePicketFile?.path;
    final imageWebBytes = kIsWeb ? imagePicketFile?.bytes : null;

    // Update if there is something to update in editprofile
    if (imagePicketFile != null || newBio != null) {
      profileCubit.updateProfileUsers(
        uid: uid,
        newBio: newBio,
        imageWebBytes: imageWebBytes,
        imageMobilePath: imageMobilePath,
      );
    }

    // If there is nothing to update in editprofile
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // Profile Loading
        if (state is ProfileLoading) {
          return ConstrainedScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 25,
                  ),
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
        if (state is ProfileLoaded) {
          Navigator.pop(context, true);
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
    );
  }

  Widget buildEditPage() {
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
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle),
                clipBehavior: Clip.hardEdge,
                child:
                    // display the selected image of mobile
                    (!kIsWeb && imagePicketFile != null)
                        ? Image.file(
                            File(imagePicketFile!.path!),
                            fit: BoxFit.cover,
                          )
                        :
                        // display the selected image of web
                        (kIsWeb && imageWebBytes != null)
                            ? Image.memory(
                                imageWebBytes!,
                                fit: BoxFit.cover,
                              )
                            :
                            // display the default image
                            CachedNetworkImage(
                                imageUrl: widget.user.profileImageUrl,
                                // loading..
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),

                                // error..
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 72,
                                  color: Theme.of(context).colorScheme.primary,
                                ),

                                // loaded
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            // Pick Image Button
            Center(
              child: ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick Image"),
              ),
            ),

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
