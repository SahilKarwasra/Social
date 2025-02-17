import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social/features/post/domain/entity/post.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // Mobile Image Pick
  PlatformFile? imagePicketFile;

  // Web Image pick
  Uint8List? imageWebBytes;

  // Text controller for Writing Caption
  final captionController = TextEditingController();

  // Get current user because the current user is uploading the post
  AppUser? currentUser;

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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

  // Create and upload a post
  void uploadPost() {
    // check if there is a caption and image provided
    if (captionController.text.isEmpty || imagePicketFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Provide a Caption and Image")));
      return;
    }

    // create a post object
    final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: captionController.text,
        imageUrl: "",
        timestamp: DateTime.now(),
        likes: [],
        comments: []);

    // Post Cubit
    final postCubit = context.read<PostCubit>();

    // Upload Post
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePicketFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePicketFile?.path);
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostsStates>(
      builder: (context, state) {
        // If the state is loading or uploading
        if (state is PostsLoading || state is PostsUploading) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // if the state is not loading or uploading
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Post"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Image preview for Mobile
            if (!kIsWeb && imagePicketFile != null)
              Image.file(File(imagePicketFile!.path!)),

            // Image preview for Web
            if (kIsWeb && imageWebBytes != null) Image.memory(imageWebBytes!),

            // Button for picking Image
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),

            // Textfield for Caption
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "Caption",
              ),
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
