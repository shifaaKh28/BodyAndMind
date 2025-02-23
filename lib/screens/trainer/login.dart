import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../common/facebook_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';
import '../common/google_auth_service.dart'; // Import GoogleAuthService


class TrainerLoginScreen extends StatefulWidget {
  @override
  _TrainerLoginScreenState createState() => _TrainerLoginScreenState();
}

class _TrainerLoginScreenState extends State<TrainerLoginScreen> {
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final GoogleAuthService _googleAuthService = GoogleAuthService(); // Google Auth Service
  bool _isLoading = false;

  // Determine if input is phone or email
  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(
        r'^0\d{9}$'); // Israel phone format (10 digits, starting with 0)
    return phoneRegex.hasMatch(input);
  }

  Future<void> _loginTrainer() async {
    final input = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    if (input.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    if (_isPhoneNumber(input)) {
      // Login with phone number
      await _loginWithPhone(input, password);
    } else {
      // Login with email
      await _loginWithEmail(input, password);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _checkTrainer(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Invalid email or password');
    }
  }

  Future<void> _loginWithPhone(String phone, String password) async {
    try {
      // Convert phone to email format stored in Firestore if applicable
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('trainers')
          .where('phone', isEqualTo: phone)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Use the found trainer's email for login
        final trainerData = snapshot.docs.first.data() as Map<String, dynamic>;
        final email = trainerData['email'];
        await _loginWithEmail(email, password);
      } else {
        _showError('Phone number not registered.');
      }
    } catch (e) {
      _showError('Error logging in with phone number.');
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
            .collection('trainers')
            .doc(uid)
            .get();

        if (traineeDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${traineeDoc['name']}!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrainerDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are not registered as a trainer.')),
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
            .collection('trainers')
            .doc(user.uid)
            .get();

        if (traineeDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${traineeDoc['name']}!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrainerDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are not registered as a trainer.')),
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

  Future<void> _checkTrainer(String uid) async {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('trainers').doc(uid).get();

    if (userDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
      Navigator.pushReplacementNamed(context, '/trainerDashboard');
    } else {
      _showError('You are not registered as a trainer.');
      await FirebaseAuth.instance.signOut();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

  Future<void> _resetPassword() async {
    final emailOrPhone = _emailOrPhoneController.text.trim();

    if (_isPhoneNumber(emailOrPhone)) {
      _showError('Password reset is only supported via email.');
      return;
    }

    if (emailOrPhone.isEmpty ||
        !RegExp(r'\S+@\S+\.\S+').hasMatch(emailOrPhone)) {
      _showError('Please enter a valid email address');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailOrPhone);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      _showError('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Trainer Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDarkTextField(controller: _emailOrPhoneController, label: 'Email or Phone', icon: Icons.person_outline),
                  SizedBox(height: 16),
                  _buildDarkTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline, obscureText: true),
                  SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _loginTrainer,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Login', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 16),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _loginWithGoogle,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      icon: Icon(Icons.g_mobiledata, color: Colors.white),
                      label: Text('Login with Google', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _loginWithFacebook,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
                      icon: Icon(Icons.facebook, color: Colors.white),
                      label: Text('Login with Facebook', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: Text('Forgot Password?', style: TextStyle(color: Colors.orange)),
                    ),
                  ),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/trainerRegister');
                      },
                      child: Text('Don’t have an account? Register here', style: TextStyle(color: Colors.orange)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Dark Themed TextField Builder
  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white), // Text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        // Label text color
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.grey[800],
        // Input field background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
