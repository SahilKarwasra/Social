import 'package:social/features/auth/domain/entities/app_users.dart';

class ProfileUsers extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUsers({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
  });

  // Function to update profile users
  ProfileUsers copyWith(
      {String? bio,
      String? imageUrl,
      List<String>? newfollowers,
      List<String>? newfollowing}) {
    return ProfileUsers(
      uid: uid,
      email: email,
      name: name,
      bio: bio ?? this.bio,
      profileImageUrl: imageUrl ?? profileImageUrl,
      followers: newfollowers ?? followers,
      following: newfollowing ?? following,
    );
  }

  // convert profile user to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  // convert json to profile user
  factory ProfileUsers.fromJson(Map<String, dynamic> json) {
    return ProfileUsers(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
