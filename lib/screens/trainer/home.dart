import 'package:flutter/material.dart';

class TrainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/trainerLogin');
          },
          child: Text(
            'Login as Trainer',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
