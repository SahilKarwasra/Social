import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/post/domain/repository/post_repo.dart';

import '../domain/entity/post.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store the post in a collection named 'posts'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      print('Creating post with ID: ${post.id}'); // Debug: Post ID
      print('Post data: ${post.toJson()}'); // Debug: Post JSON data

      await postsCollection.doc(post.id).set(post.toJson());

      print('Post successfully created!'); // Debug: Success message
    } catch (e) {
      print('Error while creating post: $e'); // Debug: Error message
      throw Exception('Error while creating post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all the post from the collection with new posts at the top
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      // convert every firestore document into a list of Post object
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception('Error while fetching posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // fetch all the post from the collection with this uid
      final postsSnapshot = await postsCollection
          .where('uid', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      // convert every firestore document into a list of Post object
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Error while fetching posts: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // get the post document from firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Check if user has already liked the post
        final hasLiked = post.likes.contains(userId);

        // update the likes list
        if (hasLiked) {
          post.likes.remove(userId); // unlike the post if already liked
        } else {
          post.likes.add(userId); // like the post if not liked
        }

        // update the post in firestore
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Error while toggling like: $e');
    }
  }
}
