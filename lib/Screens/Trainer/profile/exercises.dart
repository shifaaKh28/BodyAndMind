import 'package:flutter/material.dart';

class ExerciseLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Exercise Library Screen Coming Soon!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}