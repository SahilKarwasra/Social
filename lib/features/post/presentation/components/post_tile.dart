import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social/features/post/domain/entity/post.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDelete;

  const PostTile({
    super.key,
    required this.post,
    required this.onDelete,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // Post User
  ProfileUsers? postUser;

  // onstar up
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUsersProfile(widget.post.userId);

    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // show options for deletion/
  void showOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // Delete button
          TextButton(
            onPressed: () {
              widget.onDelete!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // tap on like button
  void toggleLike() {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like and update the ui
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // Unlike the post
      } else {
        widget.post.likes.add(currentUser!.uid); // like the post
      }
    });

    // update the like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert the unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert the like
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Profile pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),

                const SizedBox(width: 10),

                // Name of the user
                Text(
                  widget.post.userName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold),
                ),

                const Spacer(),

                // Delete post button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOption,
                    child: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.primary),
                  ),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 400),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // Buttons for like commenting and timestamp
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Like Button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLike,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(widget.post.likes.length.toString()),
                    ],
                  ),
                ),

                SizedBox(width: 20),
                // comment Button
                Icon(Icons.comment),
                Text("0"),

                // Time Stamp
                Spacer(),
                Text(widget.post.timestamp.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
