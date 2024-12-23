import 'package:flutter/material.dart';

class BodyStatsScreen extends StatefulWidget {
  @override
  _BodyStatsScreenState createState() => _BodyStatsScreenState();
}

class _BodyStatsScreenState extends State<BodyStatsScreen> {
  double height = 165;
  double weight = 60;
  double bmi = 22.0;

  double chest = 90;
  double waist = 75;
  double hips = 95;

  void _calculateBMI() {
    setState(() {
      bmi = weight / ((height / 100) * (height / 100));
    });
  }

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
          backgroundColor: Colors.grey[900],
          title: Text(
            'Edit Body Stats',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  label: 'Height (cm)',
                  icon: Icons.height,
                  initialValue: height.toString(),
                  onChanged: (value) {
                    updatedHeight = double.tryParse(value) ?? height;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight,
                  initialValue: weight.toString(),
                  onChanged: (value) {
                    updatedWeight = double.tryParse(value) ?? weight;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Chest (cm)',
                  icon: Icons.accessibility_new,
                  initialValue: chest.toString(),
                  onChanged: (value) {
                    updatedChest = double.tryParse(value) ?? chest;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Waist (cm)',
                  icon: Icons.linear_scale,
                  initialValue: waist.toString(),
                  onChanged: (value) {
                    updatedWaist = double.tryParse(value) ?? waist;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Hips (cm)',
                  icon: Icons.accessibility,
                  initialValue: hips.toString(),
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
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
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
        title: Text(
          'Body Stats',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        backgroundColor: Colors.black, // Keep the background transparent or adjust as needed
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/body_stats_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Card(
                  color: Colors.black.withOpacity(0.8),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatRow('Height', '${height.toStringAsFixed(1)} cm', Icons.height),
                        _buildStatRow('Weight', '${weight.toStringAsFixed(1)} kg', Icons.monitor_weight),
                        _buildStatRow('BMI', '${bmi.toStringAsFixed(1)}', Icons.bar_chart),
                        Divider(color: Colors.white54),
                        _buildStatRow('Chest', '${chest.toStringAsFixed(1)} cm', Icons.accessibility_new),
                        _buildStatRow('Waist', '${waist.toStringAsFixed(1)} cm', Icons.linear_scale),
                        _buildStatRow('Hips', '${hips.toStringAsFixed(1)} cm', Icons.accessibility),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: _openEditDialog,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Stats'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 30),
              SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[800],
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
    );
  }
}
