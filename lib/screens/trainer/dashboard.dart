import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swe_project/screens/common/chat_screen.dart';
import 'package:swe_project/screens/trainer/profile/schedule.dart';
import 'profile/profile_screen.dart';


class TrainerDashboard extends StatefulWidget {
  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard>
    with SingleTickerProviderStateMixin {
  String _trainerName = '';
  bool _isLoading = true;
  int _currentTabIndex = 0;

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _fetchTrainerDetails();

    // Animation Controller Initialization
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Creating staggered animations for dashboard items
    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2 * index, 1.0, curve: Curves.easeOut),
      ));
    });

    // Starting animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchTrainerDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;

      final trainerDoc = await FirebaseFirestore.instance
          .collection('trainers')
          .doc(uid)
          .get();

      setState(() {
        _trainerName = trainerDoc['name'] ?? 'Trainer';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _trainerName = 'Trainer';
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
              'assets/images/trainer_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: _isLoading
                ? Center(
                child: CircularProgressIndicator(color: Colors.blueAccent))
                : IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildDashboardContent(),
                ChatScreen(userType: 'trainer'),
                TrainerSchedule(), // Schedule screen
                _buildFeedbackScreen(),
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
          // Profile Icon Navigation
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(isTrainer: true),
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
                'Hello, $_trainerName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Let’s manage your tasks!',
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
      {'title': 'Manage Sessions', 'onTap': _showManageSessions},
      {'title': 'Chat with Trainees', 'onTap': () => _navigateToChat()},
      {'title': 'View Schedule', 'onTap': _navigateToSchedule},
      {'title': 'View Feedback', 'onTap': _showFeedbackDialog},
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
                onTap: item['onTap'],
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


  void _showManageSessions() {
    final _formKey = GlobalKey<FormState>();
    String? sessionType;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    final _capacityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage Sessions'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: sessionType,
                    items: ['Gym', 'Yoga', 'Swimming', 'Boxing', 'CrossFit']
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        sessionType = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Session Type'),
                    validator: (value) =>
                    value == null ? 'Please select a session type' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    validator: (value) =>
                    selectedDate == null ? 'Please select a date' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: selectedTime == null
                          ? 'Select Time'
                          : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    validator: (value) =>
                    selectedTime == null ? 'Please select a time' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _capacityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Capacity'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter capacity';
                      }
                      final capacity = int.tryParse(value);
                      if (capacity == null || capacity <= 0) {
                        return 'Enter a valid capacity';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final session = {
                    'trainerId': FirebaseAuth.instance.currentUser!.uid,
                    'type': sessionType,
                    'date': selectedDate,
                    'time':
                    '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                    'capacity': int.parse(_capacityController.text),
                    'enrolledUsers': [],
                  };

                  await FirebaseFirestore.instance.collection('sessions').add(session);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Session created successfully!')),
                  );
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(userType: 'trainer'),
      ),
    );
  }

  void _navigateToSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerSchedule(),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('View Feedback'),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final feedbackList = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final feedback = feedbackList[index];
                  return ListTile(
                    title: Text(feedback['traineeName'] ?? 'Unknown'),
                    subtitle: Text(feedback['comments'] ?? 'No Comments'),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
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
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback),
          label: 'Feedback',
        ),
      ],
      type: BottomNavigationBarType.fixed, // Ensures all labels/icons are displayed
    );
  }

}






