import 'package:flutter/material.dart';

import '../components/c_button.dart';
import '../components/c_textfields.dart';

class SignupPage extends StatefulWidget {
  final void Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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

                // Username, Email and Password TextFields
                CTextfields(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 22),
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
                  text: "SignUp",
                ),

                SizedBox(height: 50,),

                // Text for signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Already have an Account? ",
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        )
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                          "Login",
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .inversePrimary,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
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
