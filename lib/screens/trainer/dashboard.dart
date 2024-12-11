import 'package:flutter/material.dart';
import '../Trainer/profile/schedule.dart';
import '../Trainer/profile/trainees.dart';
import '../Trainer/profile/exercises.dart';
import '../Trainer/profile/progress.dart';
import '../Trainer/profile/notifications.dart';
import '../Trainer/profile/profile_screen.dart'; // Import Profile Screen

class TrainerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDashboardButton(
              context,
              title: 'Profile', // New Profile Button
              icon: Icons.person,
              targetScreen: ProfileScreen(isTrainer: true), // Navigate to Profile Screen
            ),
            _buildDashboardButton(
              context,
              title: 'Schedule',
              icon: Icons.schedule,
              targetScreen: TrainerSchedule(),
            ),
            _buildDashboardButton(
              context,
              title: 'Trainees',
              icon: Icons.people,
              targetScreen: TraineeProfiles(),
            ),
            _buildDashboardButton(
              context,
              title: 'Exercises',
              icon: Icons.fitness_center,
              targetScreen: ExerciseLibrary(),
            ),
            _buildDashboardButton(
              context,
              title: 'Progress',
              icon: Icons.show_chart,
              targetScreen: TrainerProgress(),
            ),
            _buildDashboardButton(
              context,
              title: 'Notifications',
              icon: Icons.notifications,
              targetScreen: NotificationsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required String title,
        required IconData icon,
        required Widget targetScreen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              title,
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
