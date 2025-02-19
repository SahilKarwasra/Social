import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/responsive/constrained_scaffold.dart';
import 'package:social/themes/theme_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // grab the theme cubit
    final themeCubit = context.read<ThemeCubit>();

    // is Dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  themeCubit.toggleTheme();
                }),
          )
        ],
      ),
    );
  }
}
