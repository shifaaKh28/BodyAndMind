import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerLoginScreen extends StatefulWidget {
  @override
  _TrainerLoginScreenState createState() => _TrainerLoginScreenState();
}

class _TrainerLoginScreenState extends State<TrainerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginTrainer() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if the user exists in the 'trainers' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('trainers')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // User is a trainer, proceed to Trainer Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        Navigator.pushReplacementNamed(context, '/trainerDashboard');
      } else {
        // User is not a trainer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not registered as a trainer.')),
        );

        // Sign out the user to prevent unauthorized access
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No trainer found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMessage')),
      );
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Login'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginTrainer,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login as Trainer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/trainerRegister'); // Match the route name exactly
              },
              child: Text('Don’t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
