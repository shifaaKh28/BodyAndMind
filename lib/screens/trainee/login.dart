import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Trainer/dashboard.dart';
import '../common/facebook_auth_service.dart';
import 'dashboard.dart';
import '../common/google_auth_service.dart'; // Import GoogleAuthService

class TraineeLoginScreen extends StatefulWidget {
  @override
  _TraineeLoginScreenState createState() => _TraineeLoginScreenState();
}

class _TraineeLoginScreenState extends State<TraineeLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GoogleAuthService _googleAuthService = GoogleAuthService(); // Google Auth Service
  bool _isLoading = false;

  Future<void> _loginTrainee() async {
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

      final uid = userCredential.user!.uid;

      // Check if the user exists in the 'trainers' collection
      DocumentSnapshot trainerDoc = await FirebaseFirestore.instance
          .collection('trainers')
          .doc(uid)
          .get();

      if (trainerDoc.exists) {
        // Redirect to Trainer Dashboard
        String trainerName = trainerDoc['name'] ?? 'Trainer';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, $trainerName! Redirecting to Trainer Dashboard...')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrainerDashboard()),
        );
        return;
      }

      // Check if the user exists in the 'trainees' collection
      DocumentSnapshot traineeDoc = await FirebaseFirestore.instance
          .collection('trainees')
          .doc(uid)
          .get();

      if (traineeDoc.exists) {
        // Redirect to Trainee Dashboard
        String traineeName = traineeDoc['name'] ?? 'Trainee';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, $traineeName! Redirecting to Trainee Dashboard...')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TraineeDashboard()),
        );
      } else {
        // User is not registered as a trainee
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not registered as a trainee.')),
        );
        FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _googleAuthService.signInWithGoogle();
      if (userCredential != null) {
        final uid = userCredential.user!.uid;

        // Check if the user exists in the 'trainees' collection
        final traineeDoc = await FirebaseFirestore.instance
            .collection('trainees')
            .doc(uid)
            .get();

        if (traineeDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${traineeDoc['name']}!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TraineeDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are not registered as a trainee.')),
          );
          FirebaseAuth.instance.signOut();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithFacebook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final FacebookAuthService facebookAuthService = FacebookAuthService();
      final user = await facebookAuthService.signInWithFacebook();

      if (user != null) {
        // Check if the user exists in the 'trainees' collection
        final traineeDoc = await FirebaseFirestore.instance
            .collection('trainees')
            .doc(user.uid)
            .get();

        if (traineeDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${traineeDoc['name']}!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TraineeDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are not registered as a trainee.')),
          );
          FirebaseAuth.instance.signOut();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook Login failed: $e')),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Cbum.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Login (התחברות)',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email (דוא"ל)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password (סיסמה)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loginTrainee,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _loginWithGoogle,
                        icon: Icon(Icons.login),
                        label: Text('Sign in with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _loginWithFacebook,
                        icon: Icon(Icons.facebook),
                        label: Text('Sign in with Facebook'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a trainee yet? ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/traineeRegister');
                            },
                            child: Text(
                              'Register here',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
