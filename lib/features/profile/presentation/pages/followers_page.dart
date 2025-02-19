import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/profile/presentation/components/c_user_tile.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/responsive/constrained_scaffold.dart';

class FollowersPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowersPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // Scaffold
      child: ConstrainedScaffold(
        // App Bar
        appBar: AppBar(
          // Tab Bar
          bottom: TabBar(
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: TabBarView(children: [
          _buildFollowersList(followers, "No Followers", context),
          _buildFollowersList(following, "No Following", context)
        ]),
      ),
    );
  }

  // Custom Widget for building user list from given profile uid
  Widget _buildFollowersList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // get each userId
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUsersProfile(uid),
                builder: (context, snapshot) {
                  // User Loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return CUserTile(user: user);
                  }

                  // loading...
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(title: Text("Loading..."));
                  }

                  // not Found or error
                  else {
                    return ListTile(title: Text("Users Not Found"));
                  }
                },
              );
            });
  }
}
