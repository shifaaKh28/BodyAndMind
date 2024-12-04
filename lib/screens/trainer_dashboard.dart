import 'package:flutter/material.dart';

class TrainerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Trainer Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
