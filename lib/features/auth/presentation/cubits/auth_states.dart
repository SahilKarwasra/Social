import '../../domain/entities/app_users.dart';

abstract class AuthStates {
  AppUser? user;
}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  final AppUser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthStates {
  final String message;
  Unauthenticated(this.message);
}

class AuthErrors extends AuthStates {
  final String message;
  AuthErrors(this.message);
}
