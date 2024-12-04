import 'package:flutter/material.dart';

class TrainerProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Trainer Progress Screen Coming Soon!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
