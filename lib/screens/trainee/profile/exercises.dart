import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Map<String, String>> exercises = [
    {'title': 'Yoga', 'subtitle': 'Calm your mind and body.', 'image': 'assets/images/yoga.png'},
    {'title': 'Strength Training', 'subtitle': 'Build your muscles effectively.', 'image': 'assets/images/strength.png'},
    {'title': 'Cardio', 'subtitle': 'Boost your stamina and endurance.', 'image': 'assets/images/cardio.png'},
    {'title': 'Stretching', 'subtitle': 'Improve your flexibility.', 'image': 'assets/images/stretching.png'},
  ];

  List<bool> isVisible = [];

  @override
  void initState() {
    super.initState();
    isVisible = List.generate(exercises.length, (index) => false);
    _animateList();
  }

  void _animateList() {
    for (int i = 0; i < exercises.length; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        if (mounted) {
          setState(() {
            isVisible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Exercises'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Exercises...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: isVisible[index] ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    child: AnimatedSlide(
                      offset: isVisible[index] ? Offset(0, 0) : Offset(0, 0.5),
                      duration: Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      child: _buildCategoryCard(
                        context,
                        title: exercises[index]['title']!,
                        subtitle: exercises[index]['subtitle']!,
                        imagePath: exercises[index]['image']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context,
      {required String title, required String subtitle, required String imagePath}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseCategoryScreen(category: title),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseCategoryScreen extends StatefulWidget {
  final String category;

  ExerciseCategoryScreen({required this.category});

  @override
  _ExerciseCategoryScreenState createState() => _ExerciseCategoryScreenState();
}

class _ExerciseCategoryScreenState extends State<ExerciseCategoryScreen> {
  List<DocumentSnapshot> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('type', isEqualTo: widget.category)
          .orderBy('date')
          .get();

      setState(() {
        sessions = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch sessions: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _enrollInSession(String sessionId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final sessionDoc = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .get();

      final enrolledUsers = List<String>.from(sessionDoc['enrolledUsers'] ?? []);

      if (!enrolledUsers.contains(uid)) {
        enrolledUsers.add(uid);

        await FirebaseFirestore.instance.collection('sessions').doc(sessionId).update({
          'enrolledUsers': enrolledUsers,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enrolled successfully!')),
        );
        _fetchSessions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.category} Sessions'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      )
          : sessions.isEmpty
          ? Center(
        child: Text(
          'No sessions found for ${widget.category}.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final data = session.data() as Map<String, dynamic>;
          final date = (data['date'] as Timestamp).toDate();
          final time = data['time'];
          final capacity = data['capacity'];
          final enrolledUsers = data['enrolledUsers'] as List<dynamic>;

          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                '${data['type']} on ${date.toLocal().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Time: $time\nCapacity: $capacity',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: enrolledUsers.contains(FirebaseAuth.instance.currentUser?.uid)
                  ? Icon(Icons.check, color: Colors.greenAccent)
                  : ElevatedButton(
                onPressed: () => _enrollInSession(session.id),
                child: Text('Enroll'),
              ),
            ),
          );
        },
      ),
    );
  }
}
