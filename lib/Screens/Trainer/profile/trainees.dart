import 'package:flutter/material.dart';

class TraineeProfiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainees'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Trainee Profiles Screen Coming Soon!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}