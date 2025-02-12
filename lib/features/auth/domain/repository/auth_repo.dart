import 'package:social/features/auth/domain/entities/app_users.dart';


// in this all the file all the possible auth actions will be Outlined not defined defined in the data layer
abstract class AuthRepo{
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);
  Future<AppUser?> registerWithEmailAndPassword(String email, String password, String name);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}