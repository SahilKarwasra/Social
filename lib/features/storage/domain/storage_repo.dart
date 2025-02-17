import 'dart:typed_data';

abstract class StorageRepo {
  // upload profile pic on mobile
  Future<String?> uploadProfilePicMobile(String path, String fileName);

  // upload profile pic on web
  Future<String?> uploadProfilePicWeb(Uint8List fileBytes, String fileName);

  // upload Post pic on mobile
  Future<String?> uploadPostPicMobile(String path, String fileName);

  // upload Post pic on web
  Future<String?> uploadPostPicWeb(Uint8List fileBytes, String fileName);
}
