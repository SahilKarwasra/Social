import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/features/auth/domain/repository/auth_repo.dart';

import '../domain/entities/app_users.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) async {
    // Attempt Sign in
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      // Create User
      AppUser user = AppUser(uid: credential.user!.uid, email: email, name: "");

      // Return User
      return user;
    } catch (e) {
      throw Exception('Login failed with error: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      // attempt sign up
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create User
      AppUser user =
          AppUser(uid: credential.user!.uid, email: email, name: name);

      // Save User Data in Firebase Firestore Database
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      // Return User
      return user;
    } catch (e) {
      throw Exception('Signup failed with error: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // Get current logged in user from firebase
    final user = firebaseAuth.currentUser;

    // if no user is logged in, return null
    if (user == null) {
      return null;
    }

    // Create User
    return AppUser(uid: user.uid, email: user.email!, name: '');
  }
}
