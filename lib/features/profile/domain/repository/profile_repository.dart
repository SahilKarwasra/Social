import 'package:social/features/profile/domain/entities/profile_users.dart';

abstract class ProfileRepo {
  Future<ProfileUsers?> getProfileUsers(String uid);
  Future<void> updateProfileUsers(ProfileUsers profileUsers);
  Future<void> toggleFollow(String currentUid, String targetUid);
}
