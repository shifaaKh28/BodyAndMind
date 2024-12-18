import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Trainee//otp.dart';

class TrainerRegisterScreen extends StatefulWidget {
  @override
  _TrainerRegisterScreenState createState() => _TrainerRegisterScreenState();
}

class _TrainerRegisterScreenState extends State<TrainerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Added Phone Controller
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerTrainer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Register trainer with Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save trainer details to Firestore
      await FirebaseFirestore.instance
          .collection('trainers')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': 'trainer',
      });

      // Notify the user of successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful! Please log in.')),
      );

      // Redirect to Trainer Login Screen
      Navigator.pushReplacementNamed(context, '/trainerLogin');
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email is already in use by another account.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
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
        SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}')),
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
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey[900], // Dark container background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Register as Trainer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name Field
                  _buildDarkTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  _buildDarkTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),

                  // Phone Field
                  _buildDarkTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  _buildDarkTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  SizedBox(height: 24),

                  // Register Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerTrainer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Register as Trainer',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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

// TextField Builder with Dark Theme
  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      // White text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        // Label text
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.grey[800],
        // Dark input background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        return null;
      },
    );
  }
}
