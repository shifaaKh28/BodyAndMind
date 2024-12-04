import 'package:flutter/material.dart';

class ExercisesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Exercises...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Exercise Categories
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCategoryCard(
                    context,
                    title: 'Strength Training',
                    icon: Icons.fitness_center,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Cardio',
                    icon: Icons.directions_run,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Yoga',
                    icon: Icons.self_improvement,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Stretching',
                    icon: Icons.accessibility_new,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'HIIT',
                    icon: Icons.timer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Category Cards
  Widget _buildCategoryCard(BuildContext context,
      {required String title, required IconData icon}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the list of exercises in the category
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseCategoryScreen(category: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Exercise Category Screen
class ExerciseCategoryScreen extends StatelessWidget {
  final String category;

  ExerciseCategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Exercises'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('List of $category exercises coming soon!'),
      ),
    );
  }
}
