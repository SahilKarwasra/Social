import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/c_button.dart';
import '../components/c_textfields.dart';
import '../cubits/auth_cubits.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login function
  void login() {
    // grab Email and password from textfields
    final String email = emailController.text;
    final String password = passwordController.text;

    // Grab Auth Cubit
    final authCubit = context.read<AuthCubit>();

    // Check if email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      // Login
      authCubit.loginWithEmailAndPassword(email, password);
    }

    // display error message if email and password are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo of the app
                Image.asset(
                  'assets/images/social.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),

                // Welcome Text
                Text(
                  'Welcome to Social!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),

                // Email and Password TextFields
                CTextfields(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 22),
                CTextfields(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: false,
                ),
                const SizedBox(height: 22),

                // Button for login
                CButton(
                  onTap: login,
                  text: "Login",
                ),

                SizedBox(
                  height: 50,
                ),

                // Text for signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New to Social?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(" Register Now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
