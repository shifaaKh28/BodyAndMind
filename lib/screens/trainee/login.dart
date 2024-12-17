import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swe_project/main.dart';
import '/Screens/Trainer/dashboard.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;


  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Check if the user exists in the 'trainees' collection
      DocumentSnapshot traineeDoc = await FirebaseFirestore.instance
          .collection('trainees')
          .doc(uid)
          .get();

      // Check if the user exists in the 'trainers' collection
      DocumentSnapshot trainerDoc = await FirebaseFirestore.instance
          .collection('trainers')
          .doc(uid)
          .get();

      if (trainerDoc.exists) {
        // Redirect trainers automatically to Trainer Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, Trainer! Redirecting to Trainer Dashboard...')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrainerDashboard()), // Redirect to Trainer Dashboard
        );
      } else if (traineeDoc.exists) {
        // Redirect trainees to Trainee Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, Trainee! Redirecting to Trainee Dashboard...')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TraineeDashboard()), // Redirect to Trainee Dashboard
        );
      } else {
        // User not found in either collection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not registered as a trainee or trainer.')),
        );
        FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login (התחברות)'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email (דוא"ל)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password (סיסמה)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Login Button
            ElevatedButton(
              onPressed: _isLoading ? null : _loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Login (התחברות)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            // Forgot Password Button
            TextButton(
              onPressed: _resetPassword,
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
