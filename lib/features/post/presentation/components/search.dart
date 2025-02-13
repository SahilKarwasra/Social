import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search"
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Search",
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
