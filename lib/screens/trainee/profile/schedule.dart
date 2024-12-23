import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _animations = List.generate(
      days.length,
          (index) => Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1, // Delays each item slightly
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Workout Schedule',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: days.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animations[index],
            child: _buildDayCard(context, days[index]),
          );
        },
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, String day) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          day,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.greenAccent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyScheduleScreen(day: day),
            ),
          );
        },
      ),
    );
  }
}

class DailyScheduleScreen extends StatelessWidget {
  final String day;

  final List<Map<String, String>> timeSlots = [
    {'slot': 'Morning', 'timeRange': '07:00 - 11:00'},
    {'slot': 'Afternoon', 'timeRange': '12:00 - 16:00'},
    {'slot': 'Evening', 'timeRange': '19:00 - 22:00'},
  ];

  DailyScheduleScreen({required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "$day's Schedule",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots[index];
          return _buildTimeSlotCard(
              context, timeSlot['slot']!, timeSlot['timeRange']!);
        },
      ),
    );
  }

  Widget _buildTimeSlotCard(
      BuildContext context, String slot, String timeRange) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          slot,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          timeRange,
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.greenAccent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HourSelectionScreen(
                day: day,
                timeSlot: slot,
                timeRange: timeRange,
              ),
            ),
          );
        },
      ),
    );
  }
}

class HourSelectionScreen extends StatefulWidget {
  final String day;
  final String timeSlot;
  final String timeRange;

  HourSelectionScreen({
    required this.day,
    required this.timeSlot,
    required this.timeRange,
  });

  @override
  _HourSelectionScreenState createState() => _HourSelectionScreenState();
}

class _HourSelectionScreenState extends State<HourSelectionScreen> {
  String? selectedHour;

  List<String> _generateHours() {
    if (widget.timeSlot == 'Morning') {
      return ['07:00', '08:00', '09:00', '10:00', '11:00'];
    } else if (widget.timeSlot == 'Afternoon') {
      return ['12:00', '13:00', '14:00', '15:00', '16:00'];
    } else {
      return ['19:00', '20:00', '21:00', '22:00'];
    }
  }

  void _showConfirmationDialog(String hour) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirm Hour'),
          content: Text('Would you like to select this hour: $hour?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedHour = hour;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hour selected: $hour'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  void _showHourPicker(String currentHour) {
    final hours = _generateHours();

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Hour',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Divider(color: Colors.white24),
              ...hours.map((hour) {
                return ListTile(
                  title: Text(
                    hour,
                    style: TextStyle(
                      color: hour == currentHour
                          ? Colors.greenAccent
                          : Colors.white70,
                    ),
                  ),
                  trailing: hour == currentHour
                      ? Icon(Icons.check, color: Colors.greenAccent)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedHour = hour;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hour changed to: $hour'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _generateHours();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${widget.day} - ${widget.timeSlot}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];
          return Card(
            color: selectedHour == hour ? Colors.greenAccent : Colors.grey[900],
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                hour,
                style: TextStyle(
                  color: selectedHour == hour ? Colors.black : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.white70),
                onPressed: () => _showHourPicker(hour),
              ),
              onTap: () => _showConfirmationDialog(hour),
            ),
          );
        },
      ),
    );
  }
}
