import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Placeholder for the number of reminders
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Reminder $index'),
                    subtitle: Text('Time: 7:00 AM'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Handle delete logic
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to Add Reminder Screen
            },
            icon: Icon(Icons.add),
            label: Text('Add Reminder'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
