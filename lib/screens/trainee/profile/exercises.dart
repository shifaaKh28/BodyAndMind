import 'package:flutter/material.dart';
import 'dart:async';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Map<String, String>> exercises = [
    {'title': 'Yoga', 'subtitle': 'Calm your mind and body.', 'image': 'assets/images/yoga.png'},
    {'title': 'Strength Training', 'subtitle': 'Build your muscles effectively.', 'image': 'assets/images/strength.png'},
    {'title': 'Cardio', 'subtitle': 'Boost your stamina and endurance.', 'image': 'assets/images/cardio.png'},
    {'title': 'Stretching', 'subtitle': 'Improve your flexibility.', 'image': 'assets/images/stretching.png'},
  ];

  List<bool> isVisible = [];

  @override
  void initState() {
    super.initState();
    // Initialize visibility to false for each exercise card
    isVisible = List.generate(exercises.length, (index) => false);
    _animateList();
  }

  // Function to trigger animations one by one
  void _animateList() {
    for (int i = 0; i < exercises.length; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        if (mounted) {
          setState(() {
            isVisible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        title: Text('Exercises'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Exercises...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),

            // Exercise Categories
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: isVisible[index] ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 700), // Slower animation
                    curve: Curves.easeInOut,
                    child: AnimatedSlide(
                      offset: isVisible[index] ? Offset(0, 0) : Offset(0, 0.5), // Slide from below
                      duration: Duration(milliseconds: 700), // Slow slide
                      curve: Curves.easeInOut,
                      child: _buildCategoryCard(
                        context,
                        title: exercises[index]['title']!,
                        subtitle: exercises[index]['subtitle']!,
                        imagePath: exercises[index]['image']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Category Cards
  Widget _buildCategoryCard(BuildContext context,
      {required String title, required String subtitle, required String imagePath}) {
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
        margin: EdgeInsets.symmetric(vertical: 12), // Increased vertical spacing
        height: 180, // Larger height for bigger images
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Rounded corners
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22, // Larger font size for title
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16, // Larger font size for subtitle
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('$category Exercises'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
