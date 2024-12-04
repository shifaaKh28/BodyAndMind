import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Progress Graphs and Stats will be displayed here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to Add Progress Screen
            },
            icon: Icon(Icons.add_chart),
            label: Text('Add Progress'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
