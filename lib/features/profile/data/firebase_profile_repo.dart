import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/profile/domain/repository/profile_repository.dart';

import '../domain/entities/profile_users.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUsers?> getProfileUsers(String uid) async {
    try {
      // get user from firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      // if user exists, return user
      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          // fetch the followers and following from firebase
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          // return profile user
          return ProfileUsers(
            uid: userData['uid'],
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfileUsers(ProfileUsers profileUsers) async {
    try {
      // Convert updated profile to json to store in firestore database
      await _firestore.collection('users').doc(profileUsers.uid).update({
        'bio': profileUsers.bio,
        'profileImageUrl': profileUsers.profileImageUrl
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      // get current user
      final currentDoc =
          await _firestore.collection('users').doc(currentUid).get();
      final targetDoc =
          await _firestore.collection('users').doc(targetUid).get();

      // if both users exist
      if (currentDoc.exists && targetDoc.exists) {
        final currentUserData = currentDoc.data();
        final targetUserData = targetDoc.data();

        if (currentUserData != null && targetUserData != null) {
          // get current user followers and following
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          // check if user is already following
          if (currentFollowing.contains(targetUid)) {
            // remove user from target user's followers
            await _firestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });

            // remove user from current user's following
            await _firestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });
          } else {
            // follow user
            await _firestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
            await _firestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
