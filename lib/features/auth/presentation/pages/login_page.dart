import 'package:flutter/material.dart';

import '../components/c_button.dart';
import '../components/c_textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onSignUpTap() {
    // Navigate to SignUp page (Implement your navigation logic)
    print("Sign Up Clicked");
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
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
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
                  onTap: () {},
                  text: "Login",
                ),

                SizedBox(height: 50,),

                // Text for signup
                Text(
                  "New to Social? Register Now",
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  )
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
