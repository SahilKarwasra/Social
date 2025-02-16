import '../../domain/entity/post.dart';

abstract class PostsStates {}

// initial state
class PostsInitial extends PostsStates {}

// loading state
class PostsLoading extends PostsStates {}

// uploading state
class PostsUploading extends PostsStates {}

// error state
class PostsError extends PostsStates {
  final String error;
  PostsError(this.error);
}

// loaded state
class PostsLoaded extends PostsStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
