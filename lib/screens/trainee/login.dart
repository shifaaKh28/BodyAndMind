import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class TraineeLoginScreen extends StatefulWidget {
  @override
  _TraineeLoginScreenState createState() => _TraineeLoginScreenState();
}

class _TraineeLoginScreenState extends State<TraineeLoginScreen> {
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginTrainee() async {
    final input = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    if (input.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    if (_isPhoneNumber(input)) {
      // Login using phone number
      await _loginWithPhone(input);
    } else {
      // Login using email
      await _loginWithEmail(input, password);
    }

    setState(() => _isLoading = false);
  }

  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^0\d{9}$'); // Ensure it starts with 0 and has 10 digits
    return phoneRegex.hasMatch(input);
  }

  Future<void> _loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _navigateToDashboard();
    } catch (e) {
      _showError('Invalid email or password');
    }
  }

  Future<void> _loginWithPhone(String phoneNumber) async {
    // Disable app verification for testing (ONLY FOR DEVELOPMENT)
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);

    String formattedPhone = '+972' + phoneNumber.substring(1); // Convert local to E.164

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToDashboard();
      },
      verificationFailed: (error) {
        _showError('Phone login failed: ${error.message}');
      },
      codeSent: (verificationId, resendToken) {
        _showOTPDialog(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }



  void _showOTPDialog(String verificationId) {
    final _otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            controller: _otpController,
            decoration: InputDecoration(labelText: 'OTP Code'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: _otpController.text.trim(),
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  _navigateToDashboard();
                } catch (e) {
                  _showError('Invalid OTP');
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TraineeDashboard()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Email/Phone Field
                  TextField(
                    controller: _emailOrPhoneController,
                    decoration: InputDecoration(
                      labelText: 'Email or Phone',
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _loginTrainee,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                  SizedBox(height: 10),

                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // Add functionality for Forgot Password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Register Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member yet? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/traineeRegister');
                        },
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
