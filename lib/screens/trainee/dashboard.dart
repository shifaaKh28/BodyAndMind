import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile/schedule.dart';
import 'profile/exercises.dart';
import 'profile/body_stats.dart';
import 'profile/profile_screen.dart';

class TraineeDashboard extends StatefulWidget {
  @override
  _TraineeDashboardState createState() => _TraineeDashboardState();
}

class _TraineeDashboardState extends State<TraineeDashboard> {
  String _traineeName = '';
  String _traineeEmail = '';
  bool _isLoading = true;
  final _chatController = TextEditingController();
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTraineeDetails();
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
        _traineeEmail = user.email ?? 'Unknown';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _traineeName = 'Trainee';
        _traineeEmail = 'Unknown';
        _isLoading = false;
      });
    }
  }

  void _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('chatMessages').add({
        'email': _traineeEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
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
                : Column(
              children: [
                if (_currentTabIndex == 0) _buildHeader(),
                Expanded(
                  child: _currentTabIndex == 0
                      ? _buildDashboardCards()
                      : _currentTabIndex == 1
                      ? _buildChatSection()
                      : _buildFeedbackScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                MaterialPageRoute(builder: (context) => TraineeProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile_icon.png'),
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
      {
        'title': 'Schedule',
        'image': 'assets/images/schedule_icon.png',
        'screen': ScheduleScreen()
      },
      {
        'title': 'Exercises',
        'image': 'assets/images/exercises_icon.png',
        'screen': ExercisesScreen()
      },
      {
        'title': 'Body Stats',
        'image': 'assets/images/body_stats_icon.jpg',
        'screen': BodyStatsScreen()
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      itemCount: dashboardItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => dashboardItems[index]['screen'],
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(dashboardItems[index]['image']),
                fit: BoxFit.cover,
              ),
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
              dashboardItems[index]['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatSection() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatMessages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final messages = snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final messageData =
                  messages[index].data() as Map<String, dynamic>;
                  final email = messageData['email'] ?? 'Unknown';
                  final message = messageData['message'] ?? '';

                  return Column(
                    crossAxisAlignment: email == _traineeEmail
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: email == _traineeEmail
                              ? Colors.blueAccent
                              : Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _chatController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Type a message',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.blue),
          onPressed: _sendMessage,
        ),
      ],
    );
  }

  Widget _buildFeedbackScreen() {
    return Center(
      child: Text(
        'Feedback Section Coming Soon!',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
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
      backgroundColor: Colors.grey[900],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback),
          label: 'Feedback',
        ),
      ],
    );
  }
}
