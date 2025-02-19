import 'package:social/features/profile/domain/entities/profile_users.dart';

abstract class SearchStates {}

// initial state
class SearchInitial extends SearchStates {}

// loaded state
class SearchLoaded extends SearchStates {
  final List<ProfileUsers?> users;
  SearchLoaded(this.users);
}

// loading state
class SearchLoading extends SearchStates {}

// error state
class SearchError extends SearchStates {
  final String error;
  SearchError(this.error);
}
