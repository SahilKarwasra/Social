import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/components/c_textfields.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social/features/post/domain/entity/comments.dart';
import 'package:social/features/post/domain/entity/post.dart';
import 'package:social/features/post/presentation/components/comment_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_states.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/features/profile/presentation/pages/profile_page.dart';

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

  // Comment text controller
  final commentController = TextEditingController();

  // open comments box when user want to type new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CTextfields(
          controller: commentController,
          hintText: "Type a comment...",
          obscureText: false,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          // save button
          TextButton(
              onPressed: () {
                addComment();
                Navigator.of(context).pop();
              },
              child: const Text("Save"))
        ],
      ),
    );
  }

  void addComment() {
    // create comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(uid: widget.post.userId),
                ),
              );
            },
            child: Padding(
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
                      const SizedBox(width: 5),
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 20),
                // comment Button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
                // Time Stamp
                Spacer(),
                Text(widget.post.timestamp.toString())
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Row(
              children: [
                // Username
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.post.text)
              ],
            ),
          ),

          BlocBuilder<PostCubit, PostsStates>(
            builder: (context, state) {
              // loaded
              if (state is PostsLoaded) {
                // final individual post
                final post = state.posts
                    .firstWhere((post) => (post.id == widget.post.id));

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentCount = post.comments.length;

                  // comment Section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];

                      // comment tile UI
                      return CommentTile(comment: comment);
                    },
                  );
                }
              }
              // loading
              if (state is PostsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // error
              else if (state is PostsError) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
