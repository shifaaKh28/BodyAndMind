import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerNotifications extends StatefulWidget {
  final String trainerId;

  TrainerNotifications({required this.trainerId});

  @override
  _TrainerNotificationsState createState() => _TrainerNotificationsState();
}

class _TrainerNotificationsState extends State<TrainerNotifications> {
  String? _selectedSessionId;
  String _message = '';

  Future<void> _sendNotification() async {
    if (_selectedSessionId == null || _message.isEmpty) return;

    final sessionDoc = await FirebaseFirestore.instance.collection('sessions').doc(_selectedSessionId).get();
    if (!sessionDoc.exists) return;

    List<dynamic> trainees = sessionDoc['enrolledUsers'] ?? [];

    // ✅ Ensure at least one recipient is stored in Firestore
    if (trainees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No trainees enrolled in this session!')));
      return;
    }



    // ✅ Create a new notification document in Firestore
    await FirebaseFirestore.instance.collection('notifications').add({
      'sessionId': _selectedSessionId,
      'trainerId': widget.trainerId,
      'message': _message,
      'timestamp': FieldValue.serverTimestamp(), // Fix: Use FieldValue.serverTimestamp() for consistency
      'recipients': trainees,  // Store trainee IDs correctly
    }).then((value) {
      print("✅ Notification stored in Firestore successfully!");
    }).catchError((error) {
      print("🔥 Error saving notification: $error");
    });
    // Get FCM Tokens
    List<String> tokens = [];
    for (String traineeId in trainees) {
      var traineeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(traineeId)
          .get();
      if (traineeDoc.exists && traineeDoc.data()?['fcmToken'] != null) {
        tokens.add(traineeDoc.data()?['fcmToken']);
      }
    }

    print("✅ Found ${tokens.length} FCM Tokens");
    if (tokens.isNotEmpty) {
      await _sendPushNotification(tokens);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notification Sent!')));
    setState(() {
      _message = '';
    });
  }

  Future<void> _sendPushNotification(List<String> tokens) async {
    const String serverKey = "YOUR_FCM_SERVER_KEY";  // Replace with your FCM Key

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final Map<String, dynamic> body = {
      "registration_ids": tokens,
      "notification": {
        "title": "New Message from Your Trainer",
        "body": "Check the app for the latest update from your trainer.",
        "sound": "default"
      },
      "priority": "high"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("✅ Push Notification Sent Successfully!");
      } else {
        print("❌ Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending FCM notification: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Notifications')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sessions')
                  .where('trainerId', isEqualTo: widget.trainerId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final sessions = snapshot.data!.docs;

                return DropdownButton<String>(
                  hint: Text('Select Session'),
                  value: _selectedSessionId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSessionId = newValue;
                    });
                  },
                  items: sessions.map((doc) {
                    Map<String, dynamic> sessionData = doc.data() as Map<String, dynamic>;
                    String sessionDate = (sessionData['date'] as Timestamp).toDate().toString();
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text("${sessionData['type']} - $sessionDate"),
                    );
                  }).toList(),
                );
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Notification Message'),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _sendNotification, child: Text('Send Notification')),
          ],
        ),
      ),
    );
  }
}
