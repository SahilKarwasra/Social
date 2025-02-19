import 'package:flutter/material.dart';
import 'package:social/features/profile/domain/entities/profile_users.dart';
import 'package:social/features/profile/presentation/pages/profile_page.dart';

class CUserTile extends StatelessWidget {
  final ProfileUsers user;

  const CUserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        subtitleTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.primary),
        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: user.uid),
              ),
            ));
  }
}
