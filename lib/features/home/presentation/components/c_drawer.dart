import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/search/presentation/pages/search_page.dart';
import 'package:social/features/settings/page/setting_page.dart';

import '../../../auth/presentation/cubits/auth_cubits.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'c_drawer_tile.dart';

class CDrawer extends StatelessWidget {
  const CDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 2,
              ),

              // Home option tile
              CDrawerTile(
                title: 'H O M E',
                icon: Icons.home,
                // Popping the menu drawer
                onTap: () => Navigator.pop(context),
              ),

              // Profile option tile
              CDrawerTile(
                title: 'P R O F I L E',
                icon: Icons.person,
                onTap: () {
                  // Popping the menu drawer
                  Navigator.of(context).pop();

                  // Get Current User If
                  final currentUser = context.read<AuthCubit>().currentUser;
                  String? uid = currentUser!.uid;

                  // Navigating to profile page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(uid: uid),
                      ));
                },
              ),

              // Search option tile
              CDrawerTile(
                title: 'S E A R C H',
                icon: Icons.search,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage())),
              ),

              // Settings option tile
              CDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.settings,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    )),
              ),

              const Spacer(),

              // Logout option tile
              CDrawerTile(
                title: 'L O G O U T',
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),

              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
