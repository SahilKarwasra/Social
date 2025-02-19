import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:social/features/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUsers>> searchUsers(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: query)
          .where("name", isLessThanOrEqualTo: "$query\uf8ff")
          .get();

      return result.docs
          .map((docs) => ProfileUsers.fromJson(docs.data()))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
