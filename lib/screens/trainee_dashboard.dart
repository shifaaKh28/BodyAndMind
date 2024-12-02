import 'package:flutter/material.dart';

class TraineeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Welcome to the Trainee Dashboard!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
