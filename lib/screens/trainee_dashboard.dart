import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TraineeDashboard extends StatelessWidget {
  // Method to log out the user
  Future<void> _logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Log out the user
    Navigator.pushReplacementNamed(context, '/'); // Navigate back to the main screen (or login screen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logoutUser(context), // Call the logout method
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Trainee Dashboard!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logoutUser(context), // Call the logout method
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
