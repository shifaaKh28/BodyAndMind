import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Trainer/profile/schedule.dart';
import '../Trainer/profile/trainees.dart';
import '../Trainer/profile/exercises.dart';
import '../Trainer/profile/progress.dart';
import '../Trainer/profile/notifications.dart';
import '../Trainer/profile/profile_screen.dart'; // Import Profile Screen

class TrainerDashboard extends StatefulWidget {
  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  String _trainerName = ''; // Holds the trainer's name
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchTrainerName();
  }

  // Fetch Trainer Name from Firestore
  Future<void> _fetchTrainerName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch trainer document from Firestore
        DocumentSnapshot trainerDoc = await FirebaseFirestore.instance
            .collection('trainers')
            .doc(user.uid)
            .get();

        if (trainerDoc.exists) {
          setState(() {
            _trainerName = trainerDoc['name'] ?? 'Trainer';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching trainer name: $e');
      setState(() {
        _trainerName = 'Trainer';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E), // Dark background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Gradient
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A2A36), Color(0xFF1E1E2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
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
                        'Today, ${_formattedDate()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
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

            // Fitness Metrics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Fitness Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Metrics Cards Row
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMetricCard(
                    title: 'Steps',
                    value: '9,158',
                    unit: 'steps',
                    icon: Icons.directions_walk,
                    color: Colors.blueAccent,
                  ),
                  _buildMetricCard(
                    title: 'Calories Burned',
                    value: '2,350',
                    unit: 'kcal',
                    icon: Icons.local_fire_department,
                    color: Colors.orangeAccent,
                  ),
                  _buildMetricCard(
                    title: 'Hydration',
                    value: '1.2',
                    unit: 'Liters',
                    icon: Icons.water_drop_outlined,
                    color: Colors.lightBlueAccent,
                  ),
                  _buildMetricCard(
                    title: 'Workout Duration',
                    value: '1h 30m',
                    unit: 'today',
                    icon: Icons.timer,
                    color: Colors.greenAccent,
                  ),
                  _buildMetricCard(
                    title: 'Recovery Score',
                    value: '85%',
                    unit: 'Optimal',
                    icon: Icons.favorite_outline,
                    color: Colors.purpleAccent,
                  ),
                  _buildMetricCard(
                    title: 'Goals Achieved',
                    value: '3/4',
                    unit: 'Today',
                    icon: Icons.check_circle_outline,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metric Card Widget
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utility Function to Format Date
  String _formattedDate() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }
}

