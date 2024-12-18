import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swe_project/screens/trainer/login.dart';
import 'package:swe_project/screens/trainer/profile/profile_screen.dart';
import 'package:swe_project/screens/trainer/register.dart';
import 'Screens/Trainee/dashboard.dart';
import 'Screens/Trainee/login.dart';
import 'Screens/Trainee/register.dart';
import 'Screens/Trainer/dashboard.dart';


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
        '/traineeLogin': (context) => LoginScreen(),
        '/generalRegister': (context) => RegisterScreen(), // Updated to ChooseRoleScreen,
        '/traineeRegister': (context) => RegisterScreen(),
        '/traineeDashboard': (context) => TraineeDashboard(),
        '/trainer': (context) => TraineeDashboard(),
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Cbum.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
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
          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                    'Body & Mind Gym',
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
              // Role Selection Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionCard(
                    context,
                    icon: Icons.shield_outlined,
                    label: 'Trainer',
                    gradientColors: [Colors.orangeAccent, Colors.deepOrange],
                    onPressed: () {
                      Navigator.pushNamed(context, '/trainerLogin');
                    },
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.person_outline,
                    label: 'Trainee',
                    gradientColors: [Colors.blueAccent, Colors.lightBlue],
                    onPressed: () {
                      Navigator.pushNamed(context, '/traineeLogin');
                    },
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
                      Navigator.pushNamed(context, '/generalRegister');
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
        ],
      ),
    );
  }

  // Custom Button Card for Trainer & Trainee Options
  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required List<Color> gradientColors,
        required VoidCallback onPressed,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // Option Card Widget
  Widget _buildOptionCard(
      BuildContext context, {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
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
