import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:social/features/profile/domain/repository/profile_repository.dart';
import 'package:social/features/profile/presentation/cubits/profile_states.dart';
import 'package:social/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  // fetch profile users using repository it is useful for loading single profile pics only since it don't return anything
  Future<void> fetchProfileUsers(String uid) async {
    try {
      emit(ProfileLoading());
      final profileUser = await profileRepo.getProfileUsers(uid);

      if (profileUser != null) {
        emit(ProfileLoaded(profileUser));
      } else {
        emit(ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // return user profile by given uid it is useful for loading multiple profile for posts
  Future<ProfileUsers?> getUsersProfile(String uid) async {
    final user = await profileRepo.getProfileUsers(uid);
    return user;
  }

  // update profile users using repository
  Future<void> updateProfileUsers({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      // get current profile user
      final currentUser = await profileRepo.getProfileUsers(uid);
      if (currentUser == null) {
        emit(ProfileError('Profile not found'));
        return;
      }
      // update profile picture
      String? imageDownloadUrl;
      final fileName = "${uid}_profile";

      // Ensuring that their is a pic to upload
      if (imageWebBytes != null || imageMobilePath != null) {
        // for mobile
        if (imageMobilePath != null) {
          // upload pic

          imageDownloadUrl = await storageRepo.uploadProfilePicMobile(
              imageMobilePath, fileName);
        }
        // for web
        else if (imageWebBytes != null) {
          // upload pic
          imageDownloadUrl =
              await storageRepo.uploadProfilePicWeb(imageWebBytes, fileName);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Image upload failed"));
          return;
        }
      }

      // update new profile
      final updatedProfileUser = currentUser.copyWith(
        bio: newBio ?? currentUser.bio,
        imageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // update in repository
      await profileRepo.updateProfileUsers(updatedProfileUser);

      // re-fetch the updated profile
      await fetchProfileUsers(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
      await fetchProfileUsers(uid);
    }
  }

  // Toggle follow / unfollow user
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      await profileRepo.toggleFollow(currentUid, targetUid);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
