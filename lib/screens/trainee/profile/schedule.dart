import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Schedule'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Weekly Calendar with Time Slots
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                _buildDayCard(context, 'Monday'),
                _buildDayCard(context, 'Tuesday'),
                _buildDayCard(context, 'Wednesday'),
                _buildDayCard(context, 'Thursday'),
                _buildDayCard(context, 'Friday'),
                _buildDayCard(context, 'Saturday'),
                _buildDayCard(context, 'Sunday'),
              ],
            ),
          ),
          // Add Exercise Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to Add Exercise Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExerciseScreen()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Add Exercise'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Day Cards
  Widget _buildDayCard(BuildContext context, String day) {
    return GestureDetector(
      onTap: () {
        // Navigate to Daily Schedule Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DailyScheduleScreen(day: day)),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            day,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

// Placeholder for Daily Schedule Screen with Time Slots
class DailyScheduleScreen extends StatelessWidget {
  final String day;

  DailyScheduleScreen({required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$day\'s Schedule'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildTimeSlotCard(context, 'Morning'),
          _buildTimeSlotCard(context, 'Afternoon'),
          _buildTimeSlotCard(context, 'Evening'),
        ],
      ),
    );
  }

  // Widget for Time Slot Cards
  Widget _buildTimeSlotCard(BuildContext context, String timeSlot) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          timeSlot,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to Time Slot Details Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeSlotDetailsScreen(
                day: day,
                timeSlot: timeSlot,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Placeholder for Time Slot Details Screen
class TimeSlotDetailsScreen extends StatelessWidget {
  final String day;
  final String timeSlot;

  TimeSlotDetailsScreen({required this.day, required this.timeSlot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$day - $timeSlot'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Add exercises for $timeSlot on $day here!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Placeholder for Add Exercise Screen
class AddExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Add exercise functionality coming soon!'),
      ),
    );
  }
}
