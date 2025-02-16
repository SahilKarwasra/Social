import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/domain/entity/post.dart';
import 'package:social/features/post/domain/repository/post_repo.dart';
import 'package:social/features/post/presentation/cubits/post_states.dart';
import 'package:social/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostsStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  // creating a new post
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;
    try {
      // handle image upload from mobile storage
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadProfilePicMobile(imagePath, post.id);
      }
      // handle image upload from web platform
      if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadProfilePicWeb(imageBytes, post.id);
      }
      // give the url to the post
      final newPost = post.copyWith(imageUrl: imageUrl);
      // create the post
      postRepo.createPost(newPost);
    } catch (e) {
      emit(PostsError("Something went wrong while creating post: $e"));
    }
  }

  // Fetch all the posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Something went wrong while fetching posts: $e"));
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsError("Something went wrong while deleting post: $e"));
    }
  }
}
