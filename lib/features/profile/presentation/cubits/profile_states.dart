import 'package:social/features/profile/domain/entities/profile_users.dart';

abstract class ProfileStates {}

// initial state
class ProfileInitial extends ProfileStates {}

// Loading state
class ProfileLoading extends ProfileStates {}

// loaded state
class ProfileLoaded extends ProfileStates {
  final ProfileUsers profileUser;
  ProfileLoaded(this.profileUser);
}

// error state
class ProfileError extends ProfileStates {
  final String error;
  ProfileError(this.error);
}
