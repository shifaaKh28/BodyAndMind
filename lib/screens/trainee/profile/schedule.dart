import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<DocumentSnapshot> enrolledSessions = [];
  List<DocumentSnapshot> upcomingSessions = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEnrolledSessions();
    _fetchUpcomingSessions();
  }

  Future<void> _fetchEnrolledSessions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final traineeDoc = await FirebaseFirestore.instance
          .collection('trainees')
          .doc(uid)
          .get();

      final enrolledSessionIds = List<String>.from(traineeDoc['enrolledSessions'] ?? []);
      if (enrolledSessionIds.isNotEmpty) {
        final enrolledSnapshots = await FirebaseFirestore.instance
            .collection('sessions')
            .where(FieldPath.documentId, whereIn: enrolledSessionIds)
            .orderBy('date')
            .get();

        setState(() {
          enrolledSessions = enrolledSnapshots.docs;
        });
      }
    }
  }

  Future<void> _fetchUpcomingSessions() async {
    final now = DateTime.now();
    final tenDaysLater = now.add(Duration(days: 10));

    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .where('date', isGreaterThanOrEqualTo: now)
        .where('date', isLessThanOrEqualTo: tenDaysLater)
        .orderBy('date')
        .get();

    setState(() {
      upcomingSessions = snapshot.docs;
    });
  }

  Future<void> _searchSessionsByDate(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .where('date', isEqualTo: date)
        .orderBy('time')
        .get();

    setState(() {
      upcomingSessions = snapshot.docs;
    });
  }

  Future<void> _enrollInSession(String sessionId) async {
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

        await FirebaseFirestore.instance.collection('trainees').doc(uid).update({
          'enrolledSessions': FieldValue.arrayUnion([sessionId]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enrolled successfully!')),
        );
        _fetchEnrolledSessions(); // Refresh enrolled sessions
        _fetchUpcomingSessions(); // Refresh upcoming sessions
      }
    }
  }

  Future<void> _unenrollFromSession(String sessionId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final sessionDoc = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .get();

      final enrolledUsers = List<String>.from(sessionDoc['enrolledUsers'] ?? []);

      if (enrolledUsers.contains(uid)) {
        enrolledUsers.remove(uid);

        await FirebaseFirestore.instance.collection('sessions').doc(sessionId).update({
          'enrolledUsers': enrolledUsers,
        });

        await FirebaseFirestore.instance.collection('trainees').doc(uid).update({
          'enrolledSessions': FieldValue.arrayRemove([sessionId]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unenrolled successfully!')),
        );
        _fetchEnrolledSessions(); // Refresh enrolled sessions
        _fetchUpcomingSessions(); // Refresh upcoming sessions
      }
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _searchSessionsByDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Schedule', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          _buildSectionTitle('Enrolled Sessions'),
          enrolledSessions.isEmpty
              ? Center(
            child: Text(
              'No enrolled sessions.',
              style: TextStyle(color: Colors.white70),
            ),
          )
              : Column(
            children: enrolledSessions.map((session) {
              return _buildSessionCard(session, enrolled: true);
            }).toList(),
          ),
          SizedBox(height: 20),
          _buildSectionTitle('Upcoming Sessions'),
          upcomingSessions.isEmpty
              ? Center(
            child: Text(
              'No upcoming sessions.',
              style: TextStyle(color: Colors.white70),
            ),
          )
              : Column(
            children: upcomingSessions.map((session) {
              return _buildSessionCard(session, enrolled: false);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSessionCard(DocumentSnapshot sessionDoc, {required bool enrolled}) {
    final session = sessionDoc.data() as Map<String, dynamic>;
    final date = (session['date'] as Timestamp).toDate();
    final time = session['time'];
    final trainerName = session['trainerName'];
    final type = session['type'];
    final capacity = session['capacity'];
    final enrolledUsers = session['enrolledUsers'] as List<dynamic>;

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          '$type on ${date.toLocal().toString().split(' ')[0]}',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: $time', style: TextStyle(color: Colors.white70)),
            Text('Trainer: $trainerName', style: TextStyle(color: Colors.white70)),
            Text('Capacity: $capacity', style: TextStyle(color: Colors.white70)),
          ],
        ),
        trailing: enrolled
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () => _unenrollFromSession(sessionDoc.id),
          child: Text('Unenroll', style: TextStyle(color: Colors.white)),
        )
            : ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => _enrollInSession(sessionDoc.id),
          child: Text('Enroll', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
