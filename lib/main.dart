import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/Trainee//register.dart';
import 'Screens//Trainee/dashboard.dart';
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
        '/traineeLogin': (context) => LoginScreen(),
        '/generalRegister': (context) => ChooseRoleScreen(), // Updated to ChooseRoleScreen,
        '/traineeRegister': (context) => RegisterScreen(),
        '/traineeDashboard': (context) => TraineeDashboard(),
        '/trainer': (context) => TrainerDashboard(),
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
                  // Subheading
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9), // Lighter white for better contrast
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7), // Subtle shadow for depth
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Main Heading
                  Text(
                    'Body & Mind Gym',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Subtext/Tagline with Motivational Quote
                  Text(
                    'Train insane or remain the same.', // Motivational Quote
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.85), // Slightly brighter white
                      letterSpacing: 1.0,
                      height: 1.5, // Improved line height
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/trainerLogin');
                    },
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.person_outline,
                    label: 'Trainee',
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
