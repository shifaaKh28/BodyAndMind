import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Trainer/profile/notifications.dart';
import '../Trainer/profile/profile_screen.dart';
import '../trainee/profile/exercises.dart';
import '../trainee/profile/progress.dart';
import '../trainee/profile/schedule.dart';

class TrainerDashboard extends StatefulWidget {
  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _trainerName = ''; // Holds the dynamically fetched trainer name
  bool _isLoading = true; // Loading state
  bool _isDarkMode = false; // Dark Mode state

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _fetchTrainerName();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fetch trainer's name from Firestore
  Future<void> _fetchTrainerName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the trainer's document from Firestore
      DocumentSnapshot trainerDoc = await FirebaseFirestore.instance
          .collection('trainers')
          .doc(uid)
          .get();

      setState(() {
        _trainerName = trainerDoc['name'] ?? 'Trainer';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _trainerName = 'Trainer'; // Fallback name
        _isLoading = false;
      });
      print('Error fetching trainer name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Trainer Dashboard',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: _isDarkMode ? Colors.white : Colors.blueAccent,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Animation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WelcomeText(name: _trainerName),
            ),

            // Progress Chart Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.white10 : Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: ProgressChart(), // Add chart here
            ),

            // Grid Options Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: [
                  AnimatedCard(
                    title: 'Profile',
                    icon: Icons.person_outline,
                  ),
                  AnimatedCard(
                    title: 'Schedule',
                    icon: Icons.calendar_today,
                  ),
                  AnimatedCard(
                    title: 'Exercises',
                    icon: Icons.fitness_center_outlined,
                  ),
                  AnimatedCard(
                    title: 'Progress',
                    icon: Icons.show_chart,
                  ),
                  AnimatedCard(
                    title: 'Notifications',
                    icon: Icons.notifications_active_outlined,
                  ),
                ],
              ),
            ),

            // Feedback Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to feedback page or show dialog
                },
                icon: Icon(Icons.feedback, color: Colors.white),
                label: Text('Send Feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Option Card Styling
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
          color: _isDarkMode
              ? Colors.grey[900]
              : color.withOpacity(0.2), // Dark background for cards
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode ? Colors.black54 : color.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: _isDarkMode ? Colors.white70 : color,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final String title;
  final IconData icon;

  AnimatedCard({required this.title, required this.icon});

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card tap action
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(_isHovered ? 20 : 16),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.blueGrey[700] : Colors.blueAccent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.white, size: 36),
            SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WelcomeText extends StatefulWidget {
  final String name;

  WelcomeText({required this.name});

  @override
  _WelcomeTextState createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Text(
        'Hello, ${widget.name}',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}


class ProgressChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 1),
                FlSpot(2, 4),
                FlSpot(3, 1.5),
                FlSpot(4, 3),
                FlSpot(5, 4.5),
                FlSpot(6, 2),
              ],
              isCurved: true,
              color: Colors.blueAccent, // Updated parameter
            ),
          ],
        ),
      ),
    );
  }
}
