import 'dart:io';
import 'dart:typed_data';

import 'package:social/features/storage/domain/storage_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageRepo implements StorageRepo {

  final SupabaseClient _supabase = Supabase.instance.client;
  final String _bucketName = "images";


  @override
  Future<String?> uploadProfilePicMobile(String path, String fileName) async {
    return await _uploadFile(path, fileName, "images");
    }

  @override
  Future<String?> uploadProfilePicWeb(Uint8List fileBytes, String fileName) async {
    return await _uploadFileBytes(fileBytes, fileName, "images");
  }

  // Helper methods for mobile platform (File)
  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {
      // Get the file from local storage
      final file = File(path);
      final filePath = "$folder/$fileName";

      // Upload the file to Supabase storage
      await _supabase.storage.from(_bucketName).upload(filePath, file);

      // Retrieve the uploaded file's public URL
      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  // Helper Method for web platform (Uint8List)
  Future<String?> _uploadFileBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {
      final filePath = "$folder/$fileName";

      // Upload the file bytes to Supabase storage
      await _supabase.storage.from(_bucketName).uploadBinary(filePath, fileBytes);

      // Retrieve the uploaded file's public URL
      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print("Web file upload failed: $e");
      return null;
    }
  }
}