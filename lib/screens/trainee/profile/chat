import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = TextEditingController();
  final String _traineeEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  void _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('chatMessages').add({
        'email': _traineeEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontSize: 20, // Adjust the font size for better visibility
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.8), // Slightly transparent black background
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow icon color to white
        ),
        elevation: 4, // Add slight shadow for a subtle 3D effect
      ),

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/chat_background.jpg', // Path to the uploaded image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatMessages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final messageData =
                        messages[index].data() as Map<String, dynamic>;
                        final email = messageData['email'] ?? 'Unknown';
                        final message = messageData['message'] ?? '';
                        final timestamp =
                        messageData['timestamp'] as Timestamp?;

                        final time = timestamp != null
                            ? TimeOfDay.fromDateTime(timestamp.toDate())
                            : null;
                        final formattedTime = time != null
                            ? '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? "AM" : "PM"}'
                            : '';

                        final firstName = email.split('@')[0];
                        final isSentByMe = email == _traineeEmail;

                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          alignment: isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSentByMe
                                  ? Colors.blueAccent
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  message,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
