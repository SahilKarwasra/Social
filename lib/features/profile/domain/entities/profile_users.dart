import 'package:social/features/auth/domain/entities/app_users.dart';

class ProfileUsers extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUsers({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
  });

  // Function to update profile users
  ProfileUsers copyWith({String? bio, String? imageUrl}) {
    return ProfileUsers(
      uid: uid,
      email: email,
      name: name,
      bio: bio ?? this.bio,
      profileImageUrl: imageUrl ?? this.profileImageUrl,
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
    );
  }
}
