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
          return ProfileUsers(
            uid: userData['uid'],
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
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
}
