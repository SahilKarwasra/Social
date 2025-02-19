import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/home/presentation/components/c_drawer.dart';
import 'package:social/features/post/presentation/components/post_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_states.dart';
import 'package:social/features/post/presentation/pages/upload_post_page.dart';
import 'package:social/responsive/constrained_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();

    // fetch all the post from cubit
    fetchAllPost();
  }

  void fetchAllPost() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          foregroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadPostPage(),
                    ))
              },
            )
          ],
        ),
        drawer: CDrawer(),
        body: BlocBuilder<PostCubit, PostsStates>(
          builder: (context, state) {
            // if state is loading or uploading
            if (state is PostsLoading && state is PostsUploading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // if state is loaded
            else if (state is PostsLoaded) {
              final allPosts = state.posts;

              if (allPosts.isEmpty) {
                return const Center(
                  child: Text("No Posts! :("),
                );
              }

              return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  // get individual posts
                  final post = allPosts[index];

                  // image
                  return PostTile(
                    post: post,
                    onDelete: () => deletePost(post.id),
                  );
                },
              );
            }

            // if state is in error
            else if (state is PostsError) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
