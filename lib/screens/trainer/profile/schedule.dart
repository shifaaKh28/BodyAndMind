import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            .orderBy('date') // Make sure Firestore is ordering sessions by `date`
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No sessions available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final sessions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final sessionData = sessions[index].data() as Map<String, dynamic>;

              // Extract data from session
              final sessionType = sessionData['type'] ?? 'Unknown';
              final timestamp = sessionData['date'];
              final capacity = sessionData['capacity'] ?? 0;
              final time = sessionData['time'] ?? 'Unknown';

              // Safely parse Firestore Timestamp
              DateTime sessionDate;
              try {
                sessionDate = (timestamp as Timestamp).toDate();
              } catch (e) {
                return ListTile(
                  title: Text('Invalid Date'),
                  subtitle: Text('Error parsing date.'),
                );
              }

              final formattedDate =
                  '${sessionDate.day}/${sessionDate.month}/${sessionDate.year}';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    sessionType,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: $formattedDate\nTime: $time\nCapacity: $capacity',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
