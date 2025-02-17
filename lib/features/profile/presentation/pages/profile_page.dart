import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/entities/app_users.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social/features/post/presentation/components/post_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_states.dart';
import 'package:social/features/profile/presentation/components/c_bio_box.dart';

import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // grab cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // grab current user from cubit
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on startup
  @override
  void initState() {
    super.initState();
    // fetch profile user data
    profileCubit.fetchProfileUsers(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(builder: (context, state) {
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
            actions: [
              // Edit Profile Button
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: loadedUser),
                    )),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),

          // Body of the screen
          body: ListView(
            children: [
              // Email of the user
              Center(
                child: Text(
                  loadedUser.email,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // Profile Pic
              CachedNetworkImage(
                imageUrl: loadedUser.profileImageUrl,
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
                imageBuilder: (context, imageProvider) => Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // Bio of the user
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      "BIO",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CBioBox(bio: loadedUser.bio),

              // Post of the user
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Row(
                  children: [
                    Text(
                      "POSTS",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // list of posts of user
              BlocBuilder<PostCubit, PostsStates>(
                builder: (context, state) {
                  // posts loaded
                  if (state is PostsLoaded) {
                    // filer posts by userId
                    final userPosts = state.posts
                        .where((posts) => posts.userId == widget.uid)
                        .toList();

                    // count posts
                    postCount = userPosts.length;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: postCount,
                      itemBuilder: (context, index) {
                        // get individual post
                        final post = userPosts[index];

                        // return post tile UI
                        return PostTile(
                          post: post,
                          onDelete: () =>
                              context.read<PostCubit>().deletePost(post.id),
                        );
                      },
                    );
                  }

                  // posts loading
                  else if (state is PostsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: Text("No Posts ;(."),
                    );
                  }
                },
              )
            ],
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
      } else if (state is ProfileError) {
        return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(state.error),
          ElevatedButton(
            onPressed: () =>
                context.read<ProfileCubit>().fetchProfileUsers(widget.uid),
            child: Text("Retry"),
          )
        ]));
      } else {
        return const Scaffold(
          body: Center(
            child: Text("Something went wrong. Please restart the app."),
          ),
        );
      }
    });
  }
}
