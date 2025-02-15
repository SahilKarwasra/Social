import 'package:flutter/material.dart';

class CBioBox extends StatelessWidget {
  final String bio;
  const CBioBox({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding inside the box
      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),

      width: double.infinity,

      // Text in the box
      child: Text(bio.isNotEmpty ? bio : "Empty Bio",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary
        )),
    );
  }
}
