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
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerTrainer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Register trainer with Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),

      );

      // Navigate to OTP Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(email: _emailController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
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
        title: Text('Trainer Registration'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    return value!.isEmpty ? 'Please enter your name' : null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return value!.isEmpty ? 'Please enter your email' : null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    return value!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerTrainer,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
