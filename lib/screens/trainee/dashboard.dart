import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swe_project/screens/common/chat_screen.dart';
import '../trainer/profile/profile_screen.dart';
import 'profile/schedule.dart';
import 'profile/exercises.dart';
import 'profile/body_stats.dart';
import 'profile/receivenotifications.dart'; // ✅ Import Notifications
import 'package:swe_project/screens/common/feedback_screen.dart' as feedback_screen;

class TraineeDashboard extends StatefulWidget {
  @override
  _TraineeDashboardState createState() => _TraineeDashboardState();
}

class _TraineeDashboardState extends State<TraineeDashboard>
    with SingleTickerProviderStateMixin {
  String _traineeName = '';
  bool _isLoading = true;
  int _currentTabIndex = 0;

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _fetchTraineeDetails();

    // Initialize animation controller for staggered animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Create staggered animations for dashboard cards
    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2 * index,
          1.0,
          curve: Curves.easeOut,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchTraineeDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;

      final traineeDoc = await FirebaseFirestore.instance
          .collection('trainees')
          .doc(uid)
          .get();

      setState(() {
        _traineeName = traineeDoc['name'] ?? 'Trainee';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _traineeName = 'Trainee';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/trainees_dashboard.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildDashboardContent(),
                ChatScreen(userType: 'trainee'),
                _buildFeedbackScreen(),
                ReceiveNotifications(), // ✅ Added Notifications Screen
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildDashboardCards(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(isTrainer: false),
                ),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
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
                'Let’s get started!',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards() {
    List<Map<String, dynamic>> dashboardItems = [
      {'title': 'Schedule', 'screen': ScheduleScreen()},
      {'title': 'Exercises', 'screen': ExercisesScreen()},
      {'title': 'Body Stats', 'screen': BodyStatsScreen()},
    ];

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(dashboardItems.length, (index) {
            final item = dashboardItems[index];
            return SlideTransition(
              position: _slideAnimations[index],
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['screen']),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFeedbackScreen() {
    return feedback_screen.FeedbackScreen(userType: 'Trainee'); // Use the FeedbackScreen widget we defined earlier
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
