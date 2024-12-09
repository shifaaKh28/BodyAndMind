import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swe_project/screens/trainer/login.dart';
import 'package:swe_project/screens/trainer/profile/profile_screen.dart';
import 'Screens/Trainee/dashboard.dart';
import 'Screens/Trainee/login.dart';
import 'Screens/Trainee/register.dart';
import 'Screens/Trainer/dashboard.dart';
import 'Screens/Trainer/home.dart';
import 'Screens/Trainer/login.dart';

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
        '/register': (context) => RegisterScreen(),
        '/traineeDashboard': (context) => TraineeDashboard(),
        '/trainer': (context) => TrainerScreen(),
        '/trainerLogin': (context) => TrainerLoginScreen(), // Add Trainer Login route
        '/trainerDashboard': (context) => TrainerDashboard(), // Add Trainer Dashboard route
        '/trainerRegister': (context) => TrainerRegisterScreen(), // Trainer Registration route
        '/trainerprofile': (context) => ProfileScreen(isTrainer: true),
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
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.fitness_center,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Body & Mind Gym',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              // Options Section
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Trainer Option
                    _buildOptionCard(
                      icon: Icons.admin_panel_settings,
                      label: 'Trainer\nמאמן',
                      onPressed: () {
                        Navigator.pushNamed(context, '/trainer');
                      },
                    ),
                    // Trainee Option
                    _buildOptionCard(
                      icon: Icons.person,
                      label: 'Trainee\nמתאמן',
                      onPressed: () {
                        Navigator.pushNamed(context, '/traineeOptions');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
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
