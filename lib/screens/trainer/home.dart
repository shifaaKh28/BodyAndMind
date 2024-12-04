import 'package:flutter/material.dart';

class TrainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/trainerLogin');
              },
              child: Text(
                'Login as Trainer',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16), // Add space between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/trainerRegister');
              },
              child: Text(
                'Register as Trainer',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
