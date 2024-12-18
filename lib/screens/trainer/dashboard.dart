import 'package:flutter/material.dart';
import '../Trainer/profile/schedule.dart';
import '../Trainer/profile/trainees.dart';
import '../Trainer/profile/exercises.dart';
import '../Trainer/profile/progress.dart';
import '../Trainer/profile/notifications.dart';
import '../Trainer/profile/profile_screen.dart';
import '../trainee/profile/exercises.dart';
import '../trainee/profile/progress.dart';
import '../trainee/profile/schedule.dart'; // Import Profile Screen

class TrainerDashboard extends StatefulWidget {
  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  String _trainerName = 'Shifaa'; // Replace with dynamic fetching if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E), // Dark background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $_trainerName',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Welcome back!',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.notifications_outlined,
                      color: Colors.white70, size: 28),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Options Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildOptionCard(
                    title: 'Profile',
                    icon: Icons.person_outline,
                    color: Colors.blueAccent,
                    targetScreen: ProfileScreen(isTrainer: true),
                  ),
                  _buildOptionCard(
                    title: 'Schedule',
                    icon: Icons.calendar_today,
                    color: Colors.greenAccent,
                    targetScreen: ScheduleScreen(),
                  ),

                  _buildOptionCard(
                    title: 'Exercises',
                    icon: Icons.fitness_center_outlined,
                    color: Colors.purpleAccent,
                    targetScreen: ExercisesScreen(),
                  ),
                  _buildOptionCard(
                    title: 'Progress',
                    icon: Icons.show_chart,
                    color: Colors.amberAccent,
                    targetScreen: ProgressScreen(),
                  ),
                  _buildOptionCard(
                    title: 'Notifications',
                    icon: Icons.notifications_active_outlined,
                    color: Colors.redAccent,
                    targetScreen: NotificationsScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Option Cards
  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget targetScreen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              title,
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
}
