import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  final String title;

  Movie(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(fontSize: 23),
      ),
      color: Colors.blue[600],
    );
  }
}
