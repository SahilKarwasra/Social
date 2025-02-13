import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const CButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Adjusted padding
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12), // Slightly reduced for a compact look
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14, // Ensure good contrast with background
            ),
          ),
        ),
      ),
    );
  }
}
