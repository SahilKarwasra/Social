import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/domain/entity/comments.dart';
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
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      // handle image upload from mobile storage
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostPicMobile(imagePath, post.id);
      }
      // handle image upload from web platform
      if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostPicWeb(imageBytes, post.id);
      }
      // give the url to the post
      final newPost = post.copyWith(imageUrl: imageUrl);
      // create the post
      postRepo.createPost(newPost);
      // re-fetch all the posts
      fetchAllPosts();
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

  // toggle like
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Something went wrong while toggling like: $e"));
    }
  }

  // add comment to the post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Something went wrong while adding comment: $e"));
    }
  }

  // delete comment from the post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Something went wrong while deleting comment: $e"));
    }
  }
}
