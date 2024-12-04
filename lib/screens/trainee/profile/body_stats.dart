import 'package:flutter/material.dart';

class BodyStatsScreen extends StatefulWidget {
  @override
  _BodyStatsScreenState createState() => _BodyStatsScreenState();
}

class _BodyStatsScreenState extends State<BodyStatsScreen> {
  // Initial body stats data
  double height = 165; // in cm
  double weight = 60; // in kg
  double bmi = 22.0;

  // Measurements
  double chest = 90; // in cm
  double waist = 75; // in cm
  double hips = 95; // in cm

  // Function to calculate BMI
  void _calculateBMI() {
    setState(() {
      bmi = weight / ((height / 100) * (height / 100));
    });
  }

  // Function to open the edit dialog
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double updatedHeight = height;
        double updatedWeight = weight;
        double updatedChest = chest;
        double updatedWaist = waist;
        double updatedHips = hips;

        return AlertDialog(
          title: Text('Edit Body Stats'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedHeight = double.tryParse(value) ?? height;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedWeight = double.tryParse(value) ?? weight;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Chest (cm)',
                    prefixIcon: Icon(Icons.accessibility_new),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedChest = double.tryParse(value) ?? chest;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Waist (cm)',
                    prefixIcon: Icon(Icons.linear_scale),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedWaist = double.tryParse(value) ?? waist;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Hips (cm)',
                    prefixIcon: Icon(Icons.accessibility),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updatedHips = double.tryParse(value) ?? hips;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  height = updatedHeight;
                  weight = updatedWeight;
                  chest = updatedChest;
                  waist = updatedWaist;
                  hips = updatedHips;
                  _calculateBMI();
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Stats'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Body Stats
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatRow(
                      'Height',
                      '${height.toStringAsFixed(1)} cm',
                      icon: Icons.height,
                    ),
                    _buildStatRow(
                      'Weight',
                      '${weight.toStringAsFixed(1)} kg',
                      icon: Icons.monitor_weight,
                    ),
                    _buildStatRow(
                      'BMI',
                      '${bmi.toStringAsFixed(1)}',
                      icon: Icons.bar_chart,
                    ),
                    Divider(),
                    _buildStatRow(
                      'Chest',
                      '${chest.toStringAsFixed(1)} cm',
                      icon: Icons.accessibility_new,
                    ),
                    _buildStatRow(
                      'Waist',
                      '${waist.toStringAsFixed(1)} cm',
                      icon: Icons.linear_scale,
                    ),
                    _buildStatRow(
                      'Hips',
                      '${hips.toStringAsFixed(1)} cm',
                      icon: Icons.accessibility,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Edit Button
            ElevatedButton.icon(
              onPressed: _openEditDialog,
              icon: Icon(Icons.edit),
              label: Text('Edit Stats'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to display individual stats with icons
  Widget _buildStatRow(String label, String value, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
