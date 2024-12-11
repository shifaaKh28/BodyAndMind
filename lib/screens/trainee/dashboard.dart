import 'package:flutter/material.dart';
import '../trainee/profile/schedule.dart';
import '../trainee/profile/exercises.dart';
import '../trainee/profile/reminders.dart';
import '../trainee/profile/progress.dart';
import '../trainee/profile/profile_screen.dart';

class TraineeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Dashboard'),
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
              title: 'Profile',
              icon: Icons.person,
              targetScreen: TraineeProfileScreen(),
            ),
            _buildDashboardButton(
              context,
              title: 'Schedule',
              icon: Icons.schedule,
              targetScreen: ScheduleScreen(),
            ),
            _buildDashboardButton(
              context,
              title: 'Exercises',
              icon: Icons.fitness_center,
              targetScreen: ExercisesScreen(),
            ),
            _buildDashboardButton(
              context,
              title: 'Reminders',
              icon: Icons.notifications,
              targetScreen: RemindersScreen(),
            ),
            _buildDashboardButton(
              context,
              title: 'Progress',
              icon: Icons.bar_chart,
              targetScreen: ProgressScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required String title, required IconData icon, required Widget targetScreen}) {
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              title,
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
