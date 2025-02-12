import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/repository/auth_repo.dart';

import '../../domain/entities/app_users.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // check if user is authenticated or not
  void checkAuthStatus() async {
    final user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated('User is not authenticated'));
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(email, password);
      _currentUser = user;
      emit(Authenticated(user!));
    } catch (e) {
      emit(AuthErrors(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  // register with email and password
  Future<void> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailAndPassword(email, password, name);
      _currentUser = user;
      emit(Authenticated(user!));
    } catch (e) {
      emit(AuthErrors(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  // logout
  Future<void> logout() async {
    await authRepo.logout();
    _currentUser = null;
    emit(Unauthenticated('User logged out'));
  }
}
