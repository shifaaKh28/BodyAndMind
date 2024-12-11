import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/Trainee//register.dart';
import 'Screens//Trainee/dashboard.dart';
import 'Screens/Trainer/home.dart';
import 'Screens/Trainee//login.dart';
import 'Screens/Trainer/login.dart';
import 'Screens/Trainer/dashboard.dart';
import 'Screens/Trainer/profile/profile_screen.dart';
import 'Screens/Trainer/register.dart';
import 'Screens/choose_role_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Body & Mind Gym',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/traineeOptions': (context) => TraineeOptionsScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => ChooseRoleScreen(), // Updated to ChooseRoleScreen,
        '/traineeRegister': (context) => RegisterScreen(),
        '/traineeDashboard': (context) => TraineeDashboard(),
        '/trainer': (context) => TrainerScreen(),
        '/trainerLogin': (context) =>
            TrainerLoginScreen(), // Add Trainer Login route
        '/trainerDashboard': (context) =>
            TrainerDashboard(), // Add Trainer Dashboard route
        '/trainerRegister': (context) =>
            TrainerRegisterScreen(), // Trainer Registration route
        '/trainerProfile': (context) =>
            ProfileScreen(isTrainer: true), // Pass the role dynamically
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF111328)
            ], // Dark theme gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image Section
            Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.greenAccent,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundImage: AssetImage(
                      'assets/images/Cbum.png', // Your new image path
                    ),
                  ),
                ),
              ],
            ),
            // Welcome Section
            Column(
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Body&Mind',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Plan your workout instantly from the app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            // Login Buttons
            Column(
              children: [
                // Login with Apple
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(
                    Icons.apple,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Login with Apple',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Login with Gmail
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.greenAccent),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(
                    Icons.mail,
                    color: Colors.greenAccent,
                  ),
                  label: Text(
                    'Login with Gmail',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Sign-up Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Option Cards
Widget _buildOptionCard({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: Color(0xFF2C2C54),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Color(0xFF4CAF50)),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

// New TraineeOptionsScreen
class TraineeOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Options (אפשרויות מתאמן)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login (התחברות)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register (רישום)'),
            ),
          ],
        ),
      ),
    );
  }
}
