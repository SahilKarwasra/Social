import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/profile/domain/repository/profile_repository.dart';
import 'package:social/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // fetch profile users using repository
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

  // update profile users using repository
  Future<void> updateProfileUsers({
    required String uid,
    String? newBio,
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

      // update bio
      final updatedProfileUser =
          currentUser.copyWith(bio: newBio ?? currentUser.bio);

      // update in repository
      await profileRepo.updateProfileUsers(updatedProfileUser);

      // re-fetch the updated profile
      await fetchProfileUsers(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
