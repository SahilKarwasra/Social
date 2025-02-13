import 'package:flutter/material.dart';

class CTextfields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CTextfields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
      ),
    );
  }
}
