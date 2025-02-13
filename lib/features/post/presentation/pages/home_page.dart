import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubits.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        actions: [
          // Logout Button
          IconButton(onPressed: () {
            context.read<AuthCubit>().logout();
          }, icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
