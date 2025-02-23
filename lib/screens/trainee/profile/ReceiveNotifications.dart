import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiveNotifications extends StatefulWidget {
  @override
  _ReceiveNotificationsState createState() => _ReceiveNotificationsState();
}

class _ReceiveNotificationsState extends State<ReceiveNotifications> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('recipients', arrayContains: user!.uid) // 🔥 Ensure filtering trainee's UID
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // ✅ Show error message
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found.')); // ✅ Show message if empty
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(notification['message'] ?? 'No message'),
                  subtitle: Text("Session: ${notification['sessionId']}"),
                  trailing: notification['timestamp'] != null
                      ? Text(notification['timestamp'].toDate().toString()) // ✅ Ensure timestamp conversion
                      : Text("No timestamp"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
