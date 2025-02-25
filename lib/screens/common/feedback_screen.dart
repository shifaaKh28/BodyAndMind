import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'feedback_model.dart' as feedback_model;

class FeedbackScreen extends StatefulWidget {
  final String userType; // 'Trainee' or 'Trainer'

  FeedbackScreen({required this.userType});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  String _category = '';
  String _comment = '';
  String _userName = '';  // New field for user name

  final CollectionReference _feedbackCollection =
  FirebaseFirestore.instance.collection('feedback');

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  List<feedback_model.Feedback> _feedbackList = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Fetch feedback data
    _fetchFeedback();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchFeedback() async {
    try {
      QuerySnapshot snapshot = await _feedbackCollection.get();
      List<feedback_model.Feedback> feedbackList = snapshot.docs.map((doc) {
        return feedback_model.Feedback.fromFirestore(doc);
      }).toList();

      setState(() {
        _feedbackList = feedbackList;
      });
    } catch (e) {
      print('Error fetching feedback: $e');
    }
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String _traineeName = _userName.isNotEmpty ? _userName : 'Anonymous';  // Default to 'Anonymous' if empty

      final feedback = feedback_model.Feedback(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userName: _traineeName,  // Save the user name
        userType: widget.userType,
        rating: _rating,
        category: _category,
        comment: _comment,
        timestamp: Timestamp.now(),
      );

      try {
        await _feedbackCollection.add(feedback.toMap()); // Save feedback with userName

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );

        _fetchFeedback(); // Refresh the list of feedback
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userType} Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feedback Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Rate your experience:', style: TextStyle(fontSize: 18)),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0; // Set rating based on the selected star
                            });
                          },
                        );
                      }),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onSaved: (value) {
                        _category = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'nickname (Optional)'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Review'),
                      onSaved: (value) {
                        _comment = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide your feedback';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitFeedback,
                      child: Text('Submit Feedback'),
                    ),
                  ],
                ),
              ),

              // Displaying Previous Feedbacks
              SizedBox(height: 20),
              Text('Previous Reviews:', style: TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: _feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = _feedbackList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(feedback.category),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.orange),
                                Text(feedback.rating.toString()),
                              ],
                            ),
                            Text(feedback.comment),
                            Text(
                              'Submitted by: ${feedback.userName}', // Display userName here
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Submitted: ${feedback.timestamp.toDate().toLocal()}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
