import 'package:social/features/profile/domain/entities/profile_users.dart';

abstract class SearchRepo {
  Future<List<ProfileUsers>> searchUsers(String query);
}
