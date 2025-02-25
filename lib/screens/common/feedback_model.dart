import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  String userId;
  String userName; // New field for user name
  String userType;
  double rating;
  String category;
  String comment;
  Timestamp timestamp;

  Feedback({
    required this.userId,
    required this.userName, // Add userName to constructor
    required this.userType,
    required this.rating,
    required this.category,
    required this.comment,
    required this.timestamp,
  });

  // Convert Feedback object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,  // Include userName in the map
      'userType': userType,
      'rating': rating,
      'category': category,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory Feedback.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Feedback(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',  // Default to 'Anonymous' if null
      userType: data['userType'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      comment: data['comment'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
