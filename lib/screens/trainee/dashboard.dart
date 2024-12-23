import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile/schedule.dart';
import 'profile/exercises.dart';
import 'profile/reminders.dart';
import 'profile/body_stats.dart';
import 'profile/profile_screen.dart';

class TraineeDashboard extends StatefulWidget {
  @override
  _TraineeDashboardState createState() => _TraineeDashboardState();
}

class _TraineeDashboardState extends State<TraineeDashboard> {
  String _traineeName = ''; // Holds the dynamically fetched trainee name
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchTraineeName();
  }

  // Fetch trainee's name from Firestore
  Future<void> _fetchTraineeName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the trainee's document from Firestore
      DocumentSnapshot traineeDoc = await FirebaseFirestore.instance
          .collection('trainees')
          .doc(uid)
          .get();

      setState(() {
        _traineeName = traineeDoc['name'] ?? 'Trainee';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _traineeName = 'Trainee'; // Fallback name
        _isLoading = false;
      });
      print('Error fetching trainee name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : Column(
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
                    backgroundImage:
                    AssetImage('assets/profile_placeholder.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $_traineeName',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ready for today’s challenges?',
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
            SizedBox(height: 20),

            // Dashboard Cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // First Row of Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDashboardCard(
                          title: 'Profile',
                          icon: Icons.person_outline,
                          color: Colors.blueAccent,
                          targetScreen: TraineeProfileScreen(),
                        ),
                        _buildDashboardCard(
                          title: 'Schedule',
                          icon: Icons.calendar_today,
                          color: Colors.greenAccent,
                          targetScreen: ScheduleScreen(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Second Row of Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDashboardCard(
                          title: 'Exercises',
                          icon: Icons.fitness_center_outlined,
                          color: Colors.orangeAccent,
                          targetScreen: ExercisesScreen(),
                        ),
                        _buildDashboardCard(
                          title: 'Reminders',
                          icon: Icons.notifications_active_outlined,
                          color: Colors.redAccent,
                          targetScreen: RemindersScreen(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Third Row of Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDashboardCard(
                          title: 'Body Stats',
                          icon: Icons.accessibility_new,
                          color: Colors.amberAccent,
                          targetScreen: BodyStatsScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard({
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
        width: MediaQuery.of(context).size.width * 0.42,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 12),
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
